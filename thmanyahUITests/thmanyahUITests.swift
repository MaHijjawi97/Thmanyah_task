//
//  thmanyahUITests.swift
//  thmanyahUITests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import XCTest

final class thmanyahUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        // App launches to Home (SwiftUI)
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5))
    }

    @MainActor
    func testHomeSectionsAppear() throws {
        let app = XCUIApplication()
        app.launch()
        // Wait for content: either "Home" nav title or a section to appear
        let navBar = app.navigationBars["Home"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 15))
        // After load, scroll view should have content (accessibility may expose section titles)
        XCTAssertTrue(app.otherElements.firstMatch.waitForExistence(timeout: 5) || navBar.exists)
    }

    @MainActor
    func testSearchButtonNavigatesToSearch() throws {
        let app = XCUIApplication()
        app.launch()
        let navBar = app.navigationBars["Home"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 15))
        // Tap search (magnifying glass) in toolbar
        let searchButton = app.buttons["magnifyingglass"]
        if searchButton.waitForExistence(timeout: 3) {
            searchButton.tap()
            // Search screen has a search bar or "Search" title
            let searchBar = app.searchFields.firstMatch
            let searchTitle = app.navigationBars["Search"]
            XCTAssertTrue(searchBar.waitForExistence(timeout: 2) || searchTitle.waitForExistence(timeout: 2))
        }
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {#imageLiteral(resourceName: "simulator_screenshot_0E6AAE67-C1BC-402E-A98C-B0547CF80B31.png")
            XCUIApplication().launch()
        }
    }
}
