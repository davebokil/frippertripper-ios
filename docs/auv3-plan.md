# AUv3 Instrument Extension for Frippertripper

## Context

The goal is to add AUv3 (Audio Unit v3) support to Frippertripper, so the
synth engine can run as a plugin inside other iOS DAW hosts (AUM, Logic Pro
for iPad, Cubasis, GarageBand) in addition to shipping as today's standalone
app.

Two research passes over the codebase (real-time audio architecture; app
lifecycle/config/state) plus a design pass converged on a clear picture: the
DSP core is already unusually well-suited to this port (explicitly
zero-AVFoundation, already unit-tested independent of the app), but several
real pieces of app-only architecture — audio session ownership, direct
cross-thread parameter writes, mono-only output, `UserDefaults.standard`
presets — do not map onto AUv3's contract as-is and need concrete rework.
This is a large, multi-stage effort that also requires non-code work (a new
Apple Developer portal App ID, App Group capability, and provisioning
profile) and a physical iOS device for any real verification — AUv3 hosts
and `auval` are not usable in Simulator, and this project has
`SUPPORTS_MACCATALYST: false`.

## Current architecture (grounding facts, verified by direct file reads)

- **Reusable essentially as-is**: `Frippertripper/Audio/Engine/SynthEngineCore.swift`
  and its sibling files (`Oscillator`, `LadderFilter`, `Envelope`, `DelayLine`,
  `Limiter`, `RampedParameter`, `CommandQueue`, `SynthTypes`, `Xorshift32`) —
  pure Swift (`import Foundation` only), `final class ... : @unchecked
  Sendable`, no `@MainActor` isolation, sample-rate/block-size agnostic
  (`prepare(sampleRate:)` / `render(frameCount:into:)` both take runtime
  values, nothing hardcoded). Already exercised directly by
  `FrippertripperTests/SynthEngineCoreTests.swift` and `ArpeggiatorTests.swift`
  with zero AVFoundation/host involvement.
- **App-only, not reusable in the extension**: `Audio/AudioEngineController.swift`
  (owns `AVAudioEngine`, builds a **mono** `AVAudioFormat(...channels: 1)`,
  wraps `SynthEngineCore` in an `AVAudioSourceNode` render block) and
  `Audio/AVAudioSessionManager.swift` (owns `AVAudioSession` category/mode,
  preferred sample rate, activation, interruption/route-change observation).
  An app extension must never touch session category/activation — the host
  process owns the shared session.
- **Mono-only today**, baked in at the `AVAudioFormat` + render-block buffer
  indexing (`bufferList[0]` only) + `SynthEngineCore.render`'s single
  `UnsafeMutablePointer<Float>` signature. AUv3 instrument hosts generally
  expect a stereo output bus.
- **Parameter delivery**: note on/off already flows through `CommandQueue`
  (`Audio/Engine/CommandQueue.swift`) — a bounded SPSC ring buffer guarded by
  `os_unfair_lock`, drained once per render call. Confirmed real-time-safety
  issue: `drain()` (lines 36-49) allocates a local `[Element]` with
  `reserveCapacity(4)` **every call**, even when the queue is empty. The
  other ~35 continuous/discrete parameters (`SynthEngine.swift:18-72`) are
  written via direct `@MainActor` `didSet` property writes straight onto
  `SynthEngineCore`/`RampedParameter`, read every sample by the render
  thread, justified only by an informal "arm64 word writes don't tear"
  argument — this does not map onto AUv3's `AUParameterTree` +
  render-time-event contract.
- **No App Group exists** (`Generated/Frippertripper.entitlements` is `<dict/>`,
  confirmed). `PresetStore.swift` persists via `UserDefaults.standard` under
  key `"com.davebokil.frippertripper.presets"`, seeded from
  `FactoryPresets.all` on first launch (`load()`, lines 47-55) — this will
  **not** be visible to an extension's own sandbox.
- **project.yml** (XcodeGen-driven, no committed `.xcodeproj`) currently
  defines exactly two targets: `Frippertripper` (application) and
  `FrippertripperTests`. Team `A8BS37XPJB`, bundle id
  `com.davebokil.frippertripper`, Release config pinned to manual signing
  with the "Frippertripper App Store" profile (scoped to that bundle id
  only).
- **Confirmed dead code**: `Frippertripper/App/FrippertripperApp.swift:5,10`
  constructs a second, unused `AudioEngineController` via `@StateObject` +
  `.environmentObject` — nothing reads it. `SynthEngine.swift:14` owns its
  own, separate, actually-used `AudioEngineController` instance. Worth
  deleting while touching this area.
- **Already-shipped build**: a build (version 3) was archived and uploaded to
  TestFlight in an earlier session, so real testers may already have
  presets saved under `.standard` — any `UserDefaults` suite change needs a
  migration path, not a clean-slate assumption.

## Recommended approach

### 1. No new framework target — share source folders across targets

XcodeGen's `sources:` lists are plain file/folder paths; the same folder can
be listed under multiple targets, each compiling its own copy. Given
`Audio/Engine`'s zero-AVFoundation dependency, this gives full code sharing
with a single edit point, no extra signing/embedding surface, and no
disruption to `FrippertripperTests`' `@testable import Frippertripper`. A
framework target would add its own Info.plist/signing surface and break the
existing test-target import for no benefit at this project's size — only
reconsider if a third consumer of this code ever appears.

### 2. Parameter/event delivery: hybrid, not "queue everything"

- **MIDI note on/off** (host's render-time MIDI event list) → translate
  directly to `core.noteOn(id:frequency:)` / `noteOff(id:)`, reusing
  `NoteFrequency.midiToFrequency(_:)` — `PianoNote.id` already *is* a MIDI
  note number, so this is close to a drop-in mapping. Keeps using today's
  `CommandQueue` note path unmodified.
- **Parameter automation** → new `AUParameterTree` mirroring
  `SynthEngine.swift`'s ~35 properties, grouped the same way as its existing
  `// MARK:` sections (VCO, Mixer, Filter, Envelope, VCA, LFO, Arp,
  Controller, Echo, Limiter) for a clean 1:1 identifier mapping.
  `internalRenderBlock` walks the host's `AURenderEvent` list and writes
  directly onto `SynthEngineCore` at the correct sub-chunk boundary — safe
  with no locking, because the render block *is* the real-time thread.
  `SynthEngineCore.render(frameCount:into:)` already takes an arbitrary
  `frameCount`/pointer, so sample-accurate automation only needs sub-chunking
  logic in the new wrapper — no `SynthEngineCore` changes required.
- **Discrete enum params** (`VcoRange`, `PwmSource`, `SubMode`, `VcaMode`,
  `LfoWaveform`, `ArpMode` — all in `SynthTypes.swift`) map to
  `AUParameterValueType.indexed` with `valueStrings` from each enum's cases.

### 3. Mono → stereo: duplicate, don't rearchitect the DSP

Keep `SynthEngineCore` single-channel. The new AUv3-only render wrapper
renders once per sub-chunk into a pre-allocated mono scratch buffer, then
copies that result into both output channels. Never render twice — that
would double-advance oscillator/envelope/`RampedParameter` state, which is
real per-sample mutable state. Scratch buffer allocated in
`allocateRenderResources()`, freed in `deallocateRenderResources()` — never
inside `internalRenderBlock`.

### 4. Real-time-safety hardening (do in Stage 0, benefits today's app too)

Fix `CommandQueue.drain` (`CommandQueue.swift:36-49`): eliminate the per-call
`[Element]` allocation by invoking `handler` directly inside the locked loop
instead of draining into a temporary array first. The handlers
(`handleNoteOn`/`handleNoteOff`/`handleAllNotesOff`) are small, non-blocking,
non-recursive — safe to call while holding `os_unfair_lock`. This matters
more under AUv3 since hosts often request smaller `maximumFramesToRender`
than today's app, so `render()`/`drain()` fires more often per second.

### 5. App Group + PresetStore, with migration

- Add `com.apple.security.application-groups: [group.com.davebokil.frippertripper]`
  to both targets' entitlements (today's `Generated/Frippertripper.entitlements`
  is empty). Must also be registered as a capability on both App IDs in the
  Apple Developer portal — a manual, non-code step.
- `PresetStore.swift`: switch `UserDefaults.standard` →
  `UserDefaults(suiteName: "group.com.davebokil.frippertripper")`.
- **Migration is required, not optional**: since a build was already
  uploaded to TestFlight, add a one-time step — if the App-Group suite has
  no data under the presets key but `.standard` does, copy it over before
  falling back to factory-preset seeding.
- Extension should never seed factory presets itself, to avoid a race where
  a host loads the extension before the app has ever launched once. Add
  `PresetStore.init(seedIfEmpty: Bool = true)`; the extension constructs
  with `false`.

### 6. UI reuse via a decoupled `SynthEngine`

Refactor `SynthEngine` (`ViewModel/SynthEngine.swift:14,78-81`) to receive
its `SynthEngineCore` via init injection plus an optional `onFirstNote`
closure, instead of owning `AudioEngineController` directly:

```swift
init(core: SynthEngineCore, onFirstNote: (() -> Void)? = nil)
```

`ContentView.swift` builds its own `AudioEngineController` as a sibling
`@State`, passes `core: audioEngineController.core, onFirstNote: {
audioEngineController.start() }`, and its `onAppear`/`scenePhase` handlers
call `audioEngineController.start()/stop()` directly instead of through
`engine.audioEngineController`. Delete the dead
`@StateObject private var engine = AudioEngineController()` +
`.environmentObject(engine)` in `FrippertripperApp.swift:5,10` while in this
area.

With this change, every existing SwiftUI panel view (`Views/FrontPanel/**`,
`Views/Controls/**`, `Views/Keyboard/PianoKeyboardView.swift`, etc. — all
already just take `@Bindable var engine: SynthEngine`, no app-only coupling
found anywhere in them) works unmodified inside the extension's own
`AUViewController`-hosted `UIHostingController`, constructing
`SynthEngine(core: <the AU's own core>, onFirstNote: nil)`.

Extension UI scope (full `ContentView` chrome vs. a slimmed panel-only view;
whether `PianoKeyboardView` belongs, since most hosts supply their own MIDI
keyboard) is a product decision to make at Stage 4, not now.

### 7. project.yml / XcodeGen changes

New `FrippertripperAU` target, `type: app-extension`:
- `sources:`: `Audio/Engine`, `ViewModel`, `Views` (shared with the app) plus
  a new extension-only folder for the `AUAudioUnit` subclass, `AUViewController`,
  and render/event wrapper.
- `PRODUCT_BUNDLE_IDENTIFIER: com.davebokil.frippertripper.auv3`,
  `DEVELOPMENT_TEAM: A8BS37XPJB`, same Debug-Automatic / Release-Manual split
  as the app target — but Release needs a **new** provisioning profile (the
  existing "Frippertripper App Store" profile is scoped to
  `com.davebokil.frippertripper` only).
- `info:` with an `NSExtension` dict: `NSExtensionPointIdentifier:
  com.apple.AudioUnit-UI`, and an `AudioComponents` array with `type: aumu`
  (Music Device/Instrument, not `aufx`), plus a manufacturer code, subtype
  code, and display name. **These 4-character codes are permanent once
  shipped** — hosts key saved sessions off them. Confirm exact values before
  Stage 1 (a reasonable starting proposal: manufacturer `Dbkl`, subtype
  `Frip`).
- `entitlements:` with the App Group.

Container `Frippertripper` target: add `dependencies: - target:
FrippertripperAU` (embeds/signs the extension into the app), add the same
App Group to its own entitlements, add the extension to the `Frippertripper`
scheme's `build.targets`.

**Non-code blocker, start in parallel with Stage 1**: a new App ID
(`com.davebokil.frippertripper.auv3`) must be registered in the Apple
Developer portal, the App Group capability enabled on both App IDs, and a
new Distribution provisioning profile created — none of this is achievable
by editing repo files, and it's likely the actual critical-path bottleneck.

## Staged sequence (natural checkpoints)

- **Stage 0** (ships inside today's app, no AUv3 yet): fix
  `CommandQueue.drain`'s allocation; decouple `SynthEngine` from
  `AudioEngineController`; migrate `PresetStore` to App-Group `UserDefaults`
  with the `.standard`-fallback migration + `seedIfEmpty`. *Verify*: existing
  test suite (`SynthEngineCoreTests`, `ArpeggiatorTests`, `PresetTests`)
  passes unmodified; manually confirm no preset data loss on a device/simulator
  that already has saved presets.
- **Stage 1** ("hello tone" checkpoint): new extension target, hardcoded
  stereo output, a trivial test-tone `internalRenderBlock` — **no
  `SynthEngineCore` involvement yet**, isolating target/signing/
  `AudioComponents`/entitlement risk from DSP-integration risk. Kick off the
  Developer-portal provisioning in parallel. *Verify*: `xcodegen generate` +
  build; on a physical device, `pluginkit -m -p com.apple.AudioUnit-UI` to
  confirm registration; load in a host (AUM) and confirm tone plays at the
  right pitch/sample rate/stereo.
- **Stage 2** (real DSP, no automation yet): share `Audio/Engine` into the
  extension; wire `SynthEngineCore` + the mono-duplicate wrapper +
  `allocateRenderResources()`/`deallocateRenderResources()` scratch buffer;
  MIDI note on/off via `midiToFrequency`. *Verify*: play notes from AUM's
  MIDI keyboard, confirm audio/pitch/stereo.
- **Stage 3** (parameter tree + automation): build the `AUParameterTree`,
  wire render-time automation events. *Verify*: unit-test the
  address↔property mapping in isolation; on-device, confirm AUM's generic
  parameter UI and recorded automation both reach the synth.
- **Stage 4** (custom SwiftUI UI): decide UI scope; build the
  `AUViewController` hosting the reused SwiftUI views. *Verify*: confirm
  turning a knob in the custom UI produces the same host-visible automation
  as the generic host UI — must go through the parameter tree, not bypass it
  by writing straight to `SynthEngineCore`.
- **Stage 5** (shared presets + `fullState`): confirm App-Group preset
  round-trip on-device; implement `AUAudioUnit.fullState` for host session
  save/restore (distinct from Frippertripper's own preset library).
- **Stage 6** (polish + host matrix + submission): broader host testing
  (Cubasis, Logic Pro for iPad, GarageBand); App Store submission — Apple
  manually tests AUv3 extensions in a host during review, historically a
  slower/pickier lane than a plain app update; budget schedule accordingly.

## Testing/verification reality check

- `SynthEngineCoreTests.swift`/`ArpeggiatorTests.swift` already validate the
  shared DSP core with zero AVAudioEngine/host involvement and need no
  changes — they keep passing regardless of which target consumes the code.
- Write the new event-chunking/parameter-mapping logic as plain,
  `AUAudioUnit`-independent Swift helpers, physically placed in a shared
  sources folder (even though the app itself never calls them at runtime),
  specifically so they stay unit-testable via the existing
  `@testable import Frippertripper` pattern (`FrippertripperTests` only
  links the app target today).
- What genuinely needs a device+host, not XCTest: bus-format negotiation
  with a host, whether `AUParameterTree` wiring actually reaches a host's
  automation UI, whether the extension is discoverable/loadable at all. Use
  `pluginkit -m -p com.apple.AudioUnit-UI` / Console.app log filtering first
  before assuming a deeper bug; a physical device + a real host app (AUM,
  ~$20, is the practical standard) for actual audio verification.
- **Do not rely on Simulator or `auval`**: AUv3 host apps (AUM, Cubasis,
  etc.) are iOS-only and not built for Simulator, whose Core Audio/AU
  hosting has real historical gaps. `auval` is macOS-only and requires Mac
  Catalyst, which this project explicitly disables
  (`SUPPORTS_MACCATALYST: false` in `project.yml`).

## Critical files

- `project.yml` — target/scheme/entitlements definitions (XcodeGen source of truth)
- `Frippertripper/Audio/Engine/SynthEngineCore.swift` — the reusable render core
- `Frippertripper/Audio/Engine/CommandQueue.swift` — note-event queue, needs the allocation fix
- `Frippertripper/Audio/AudioEngineController.swift` — app-only AVAudioEngine/graph owner
- `Frippertripper/Audio/AVAudioSessionManager.swift` — app-only session owner
- `Frippertripper/ViewModel/SynthEngine.swift` — the ~35-parameter surface, needs the init-injection refactor
- `Frippertripper/ViewModel/PresetStore.swift` — needs App-Group suite + migration
- `Frippertripper/App/FrippertripperApp.swift`, `Frippertripper/App/ContentView.swift` — dead-code cleanup + engine wiring
- `Generated/Frippertripper.entitlements` — needs the App Group entry
- `Frippertripper/Resources/PrivacyInfo.xcprivacy` — needs to cover App Group UserDefaults access, and the extension needs its own copy

## Open decisions (deliberately deferred to the relevant stage, not blocking this plan)

- AudioComponent manufacturer/subtype codes + display name — decide before Stage 1 (permanent once shipped).
- Extension UI scope: full chrome vs. panel-only, host-MIDI-only vs. including the on-screen keyboard — decide at Stage 4.
- Whether to add `UIBackgroundModes: audio` to the standalone app so looped/echoing audio survives backgrounding — orthogonal to AUv3 itself, but worth deciding in the same pass since it touches the same audio-session code paths.
