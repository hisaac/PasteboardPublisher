// swiftlint:disable implicitly_unwrapped_optional

import XCTest
import Combine
@testable import PasteboardPublisher

final class PasteboardPublisherTests: XCTestCase {
	var testPasteboard: NSPasteboard!

	override func setUpWithError() throws {
		testPasteboard = NSPasteboard.withUniqueName()
	}

	override func tearDownWithError() throws {
		testPasteboard.releaseGlobally()
	}

	func testPublishOnPasteboardChange() {
		let mockPasteboardItemArray = [NSPasteboardItem()]
		var changeCount = testPasteboard.changeCount
		let pasteboardPublisher = testPasteboard.publisher()
			.sink { _ in
				changeCount += 1
			}

		testPasteboard.clearContents()
		XCTAssertTrue(testPasteboard.writeObjects(mockPasteboardItemArray))
		XCTAssertEqual(changeCount, testPasteboard.changeCount)
	}
}
