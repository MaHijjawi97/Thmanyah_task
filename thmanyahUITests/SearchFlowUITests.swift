//
//  SearchFlowUITests.swift
//  thmanyahUITests
//
//  Smoke tests for the Search flow.
//

import XCTest

final class SearchFlowUITests: XCTestCase {
    func testSearchOpenAndClear() {
        let app = XCUIApplication()
        app.launch()

        // Open search from the Home toolbar button (magnifying glass).
        app.buttons.matching(identifier: "SearchButton").firstMatch.tap()

        let searchField = app.textFields.element
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))

        searchField.tap()
        searchField.typeText("test")

        // Tap clear/close button if present.
        if app.buttons["xmark.circle.fill"].exists {
            app.buttons["xmark.circle.fill"].tap()
        }
    }
}

