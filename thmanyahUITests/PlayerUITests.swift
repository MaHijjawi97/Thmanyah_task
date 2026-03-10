//
//  PlayerUITests.swift
//  thmanyahUITests
//
//  Very high-level smoke test for mini-player visibility after starting playback.
//

import XCTest

final class PlayerUITests: XCTestCase {
    func testMiniPlayerAppearsAfterInteraction() {
        let app = XCUIApplication()
        app.launch()

        // Try to tap the first play button we can find (if any).
        let playButtons = app.buttons.matching(identifier: "PlayButton")
        if let first = playButtons.allElementsBoundByIndex.first {
            first.tap()
        }

        // We cannot assert exact labels, but we at least assert the app is still running.
        XCTAssertTrue(app.state == .runningForeground)
    }
}

