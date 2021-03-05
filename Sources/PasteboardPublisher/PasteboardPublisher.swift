import AppKit
import Combine

/// A custom `Subscription` to capture changes to the items in the given `NSPasteboard`
public final class PasteboardSubscription<SubscriberType: Subscriber, Pasteboard: NSPasteboard>: Subscription where SubscriberType.Input == [NSPasteboardItem] {
	private var subscriber: SubscriberType?
	private let pasteboard: NSPasteboard
	private var timerPublisher: AnyCancellable?
	private var internalChangeCount: Int

	public init(subscriber: SubscriberType, pasteboard: Pasteboard) {
		self.subscriber = subscriber
		self.pasteboard = pasteboard
		internalChangeCount = self.pasteboard.changeCount
		startTimer()
	}

	private func startTimer() {
		timerPublisher = Timer.publish(every: 0.01, on: .main, in: .default)
			.autoconnect()
			.sink { [weak self] _ in
				self?.maybePublishUpdatedPasteboardItems()
			}
	}

	// We do nothing here as we only want to send events when they occur
	public func request(_ demand: Subscribers.Demand) {}

	public func cancel() {
		timerPublisher?.cancel()
		subscriber = nil
	}

	private func maybePublishUpdatedPasteboardItems() {
		if internalChangeCount != pasteboard.changeCount,
		   let pasteboardItems = pasteboard.pasteboardItems {
			_ = subscriber?.receive(pasteboardItems)
			internalChangeCount = pasteboard.changeCount
		}
	}
}

/// A custom `Publisher` that publishes events when the contents of the given `NSPasteboard` changes
public struct PasteboardPublisher: Publisher {
	public typealias Output = [NSPasteboardItem]
	public typealias Failure = Never

	private let pasteboard: NSPasteboard

	public init(pasteboard: NSPasteboard = NSPasteboard.general) {
		self.pasteboard = pasteboard
	}

	public func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Never, S.Input == [NSPasteboardItem] {
		let subscription = PasteboardSubscription(subscriber: subscriber, pasteboard: pasteboard)
		subscriber.receive(subscription: subscription)
	}
}

// Extend `NSPasteboard` to add a default publisher method
extension NSPasteboard {
	public func publisher() -> PasteboardPublisher {
		return PasteboardPublisher(pasteboard: self)
	}
}
