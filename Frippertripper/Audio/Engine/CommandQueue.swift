import os

/// A single-producer/single-consumer command queue: the UI thread pushes note
/// on/off events, the render thread drains them at the top of each render block.
///
/// This uses `os_unfair_lock` rather than a truly lock-free structure. iOS 17 (our
/// deployment target) predates the `Synchronization` framework's lock-free `Atomic`
/// (iOS 18+), and the project deliberately takes no SPM dependencies (e.g.
/// swift-atomics) to stay consistent with the source app's dependency-free ethos.
/// Note events are rare relative to the sample rate and the critical section is a
/// few words of array bookkeeping, so contention/priority-inversion risk here is
/// negligible in practice — this is a standard, shipped pattern for infrequent
/// cross-thread audio commands, distinct from the per-sample parameter reads
/// elsewhere in the engine (which avoid locking entirely).
final class CommandQueue<Element>: @unchecked Sendable {
    private var buffer: [Element?]
    private var head = 0
    private var tail = 0
    private let capacity: Int
    private var lock = os_unfair_lock()

    init(capacity: Int) {
        self.capacity = capacity
        buffer = [Element?](repeating: nil, count: capacity)
    }

    func push(_ item: Element) {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        let next = (tail + 1) % capacity
        guard next != head else { return } // full: drop rather than block the audio thread
        buffer[tail] = item
        tail = next
    }

    /// Calls `handler` directly inside the locked loop rather than draining into a
    /// temporary array first, avoiding a per-call heap allocation on the render
    /// thread. Safe because the handlers (`handleNoteOn`/`handleNoteOff`/
    /// `handleAllNotesOff`) are small, non-blocking, and never push back onto this
    /// same queue (`os_unfair_lock` is non-reentrant).
    func drain(_ handler: (Element) -> Void) {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        while head != tail {
            if let item = buffer[head] {
                buffer[head] = nil
                handler(item)
            }
            head = (head + 1) % capacity
        }
    }
}
