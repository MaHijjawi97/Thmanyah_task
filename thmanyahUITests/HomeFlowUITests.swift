//
//  HomeFlowUITests.swift
//  thmanyahUITests
//
//  Basic smoke tests for the Home screen.
//

import XCTest

final class HomeFlowUITests: XCTestCase {
    func testHomeLoadsAndShowsSections() {
        let app = XCUIApplication()
        app.launch()

        // Expect at least one section title to appear (using the localized Home title).
        XCTAssertTrue(app.staticTexts[NSLocalizedString("home.title", comment: "")].exists)
    }
}

