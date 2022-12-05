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

	func testPublishOnPasteboardChange() throws {
		// Given
		var changeCount = testPasteboard.changeCount // 0
		_ = testPasteboard.publisher()
			.sink { _ in
				changeCount += 1 // 1
			}

		// When
		XCTAssertTrue(testPasteboard.writeObjects([]))

		// Then
		XCTAssertEqual(changeCount, testPasteboard.changeCount)
	}
}
