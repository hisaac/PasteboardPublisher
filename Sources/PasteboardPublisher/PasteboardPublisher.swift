import AppKit
import Combine

public final class PasteboardPublisher: Publisher {
	public typealias Output = [NSPasteboardItem]
	public typealias Failure = Never

	private let timerPublisher: Timer.TimerPublisher

	public init(every interval: TimeInterval = 0.01,
		 tolerance: TimeInterval? = nil,
		 on runLoop: RunLoop = .main,
		 in mode: RunLoop.Mode = .default,
		 options: RunLoop.SchedulerOptions? = nil) {

		timerPublisher = Timer.publish(
			every: interval,
			tolerance: tolerance,
			on: runLoop,
			in: mode,
			options: options
		)
	}

	public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, [NSPasteboardItem] == S.Input {
		subscriber.receive(subscription: Inner(parent: self, downstream: subscriber))
	}

	private typealias Parent = PasteboardPublisher

	private final class Inner<Downstream: Subscriber>: Subscription where Downstream.Input == Output, Downstream.Failure == Failure {

		typealias Input = Downstream.Input
		typealias Failure = Downstream.Failure

		private let pasteboard = NSPasteboard.general
		private var parent: Parent?
		private var downstream: Downstream?
		private var timer: AnyCancellable?
		private var internalChangeCount = -1

		init(parent: Parent, downstream: Downstream) {
			self.parent = parent
			self.downstream = downstream
		}

		func request(_ demand: Subscribers.Demand) {
			precondition(demand > 0, "Invalid request of zero demand")

			guard let parent = parent else { return }

			if timer == nil {
				internalChangeCount = pasteboard.changeCount
				timer = parent.timerPublisher.autoconnect().sink { [weak self] _ in
					guard let self = self else { return }
					self.pollAndMaybeSend()
				}
			}
		}

		func cancel() {
			guard parent != nil else { return }
			timer?.cancel()
			timer = nil
			downstream = nil
			parent = nil
		}

		func pollAndMaybeSend() {
			guard internalChangeCount != pasteboard.changeCount,
				  parent != nil,
				  let downstream = downstream,
				  let pasteboardItems = pasteboard.pasteboardItems else {
				return
			}

			internalChangeCount = pasteboard.changeCount
			_ = downstream.receive(pasteboardItems)
		}
	}
}
