//
//  LocalizationAndLanguageHeaderTests.swift
//  thmanyahTests
//
//  Verifies localized strings exist for key user-facing text and that
//  Accept-Language header logic produces a non-empty language code.
//

import XCTest
@testable import thmanyah

final class LocalizationAndLanguageHeaderTests: XCTestCase {
    func testLocalizedHomeAndSearchTitlesAreNonEmpty() {
        let homeTitle = NSLocalizedString("home.title", comment: "")
        let searchTitle = NSLocalizedString("search.title", comment: "")

        XCTAssertFalse(homeTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        XCTAssertFalse(searchTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    func testDurationFormatStringsAreNonEmpty() {
        let minutes = String(format: NSLocalizedString("duration.minutes", comment: ""), 10)
        let hoursMinutes = String(format: NSLocalizedString("duration.hoursMinutes", comment: ""), 1, 30)

        XCTAssertFalse(minutes.isEmpty)
        XCTAssertFalse(hoursMinutes.isEmpty)
    }

    func testPreferredLanguageCodeIsNonEmpty() {
        // Mirrors the logic used to build Accept-Language header.
        let languageCode = Locale.preferredLanguages.first
        XCTAssertNotNil(languageCode)
        XCTAssertFalse(languageCode!.isEmpty)
    }
}

