import AppKit
import Combine

public struct PasteboardPublisher: Publisher {
	public typealias Output = [NSPasteboardItem]
	public typealias Failure = Never

	private let timerPublisher: AnyPublisher<Output, Failure>

	public init(pasteboard: NSPasteboard) {
		timerPublisher = Timer.publish(every: 0.01, on: .main, in: .default)
			.autoconnect()
			.map { _ in pasteboard.changeCount }
			.removeDuplicates()
			.map { _ in pasteboard.pasteboardItems ?? [] }
			.eraseToAnyPublisher()
	}

	public func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Self.Failure, S.Input == Self.Output {
		timerPublisher.receive(subscriber: subscriber)
	}
}

// Extend `NSPasteboard` to add a convenience method for creating a default publisher
extension NSPasteboard {
	/// A convenience method for creating a `PasteboardPublisher` for this `NSPasteboard`
	/// - Returns: A `PasteboardPublisher` for this `NSPasteboard`
	public func publisher() -> PasteboardPublisher {
		return PasteboardPublisher(pasteboard: self)
	}
}
