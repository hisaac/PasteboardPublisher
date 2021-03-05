import XCTest
import Combine
@testable import PasteboardPublisher

final class PasteboardPublisherTests: XCTestCase {
	var testPasteboard: NSPasteboard!

	override func setUpWithError() throws {
		testPasteboard = NSPasteboard(name: NSPasteboard.Name("testPasteboard"))
	}

	override func tearDownWithError() throws {
		print(testPasteboard.clearContents())
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
