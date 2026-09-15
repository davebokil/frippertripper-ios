# REVE Model 1

A native iOS monophonic synthesizer, inspired by classic analog mono-synths
(SH-101-style architecture: VCO → mixer → filter → VCA, plus arpeggiator,
LFO, and an echo/limiter FX rack). Built with SwiftUI and a from-scratch,
zero-AVFoundation DSP engine.

> The app is displayed to users as "REVE Model 1"; the underlying Xcode
> project, target, scheme, and bundle identifier
> (`com.davebokil.frippertripper`) remain named `Frippertripper` and are
> referenced as such throughout the commands below.

## Features

- **VCO** — selectable octave range (16'/8'/4'/2'), fine tune, variable pulse
  width with manual/envelope/LFO modulation source
- **Source mixer** — saw, pulse, sub-oscillator (3 sub modes), noise
- **Filter** — 4-pole ladder-style lowpass with resonance, envelope amount,
  LFO, and keyboard tracking
- **Envelope** — one ADSR shared across filter, PWM, and VCA
- **VCA** — envelope or gate mode
- **LFO** — triangle/square/sample-and-hold/noise, routable to pitch
- **Arpeggiator** — Up / Down / Up-Down / Random modes, 1–4 octave range,
  Hold (latch notes into the arp pool after release)
- **Controller** — pitch-bend lever with independent VCO/filter sensitivity,
  portamento
- **FX rack** — echo (time/repeat/volume) and a limiter (threshold/ceiling)
- **On-screen keyboard** — glissando-capable, adjustable octave range/span,
  and a Hold mode that latches notes so both hands stay free for the panel
- **Patch management** — 100 factory presets, save/rename/delete your own,
  Init (reset to default), Random (randomize the whole front panel), and the
  current patch is remembered across app launches

## Project structure

```
Frippertripper/
  App/            App entry point, root ContentView (layout/navigation)
  Audio/
    Engine/       Pure-Swift DSP core (Oscillator, LadderFilter, Envelope,
                   DelayLine, Limiter, SynthEngineCore) — no AVFoundation,
                   fully unit-testable in isolation
    AudioEngineController.swift   Wraps the DSP core in an AVAudioEngine node
    AVAudioSessionManager.swift   AVAudioSession category/activation/routing
  ViewModel/      SynthEngine (@Observable parameter surface), SynthPreset,
                   PresetStore, FactoryPresets
  Views/          SwiftUI front panel, keyboard, FX sheet, preset browser
FrippertripperTests/   XCTest suite for the DSP core and preset persistence
```

The DSP engine (`Audio/Engine/`) is intentionally decoupled from
AVFoundation and SwiftUI — it takes a sample rate and block size at
`prepare`/`render` time and has no app-lifecycle dependencies, which is what
makes it independently testable (see `docs/auv3-plan.md` for a look at
reusing it inside an AUv3 plugin extension).

## Requirements

- Xcode 16+
- iOS 17+ deployment target
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)
  — the `.xcodeproj` is generated from `project.yml` and is not checked in

## Building

```sh
xcodegen generate
open Frippertripper.xcodeproj
```

Or from the command line:

```sh
xcodegen generate
xcodebuild -project Frippertripper.xcodeproj -scheme Frippertripper \
  -destination 'platform=iOS Simulator,name=iPhone 17' build
```

## Testing

```sh
xcodebuild -project Frippertripper.xcodeproj -scheme Frippertripper \
  -destination 'platform=iOS Simulator,name=iPhone 17' test
```

Tests cover the DSP primitives (oscillator, filter, envelope, delay line,
limiter), the arpeggiator, the audio engine controller, and preset
save/load/session-persistence round-tripping.

## Releasing

1. Bump `CURRENT_PROJECT_VERSION` in `project.yml`, then `xcodegen generate`
2. Archive: `xcodebuild ... -configuration Release archive`
3. Export/upload to App Store Connect via
   `xcodebuild -exportArchive` with an App Store Connect API key (manual
   signing, "Frippertripper App Store" distribution profile)

Release code-signing is configured manually in `project.yml` under the
Frippertripper target's `configs.Release` block rather than left on
Automatic, since Automatic signing insists on also resolving a Development
profile even for archive builds.
