//
//  ThemeManagerTests.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import SwiftUI
import XCTest
@testable import thmanyah

final class ThemeManagerTests: XCTestCase {
    func testThemeKeyDefaultValue() {
        let defaultValue = ThemeKey.defaultValue
        XCTAssertTrue(defaultValue.colors is AppTheme.Type)
        XCTAssertTrue(defaultValue.typography is AppTypography.Type)
    }

    func testAppThemeValuesDefault() {
        let values = AppThemeValues.default
        XCTAssertTrue(values.colors is AppTheme.Type)
        XCTAssertTrue(values.typography is AppTypography.Type)
    }

    func testEnvironmentAppThemeGetSet() {
        var env = EnvironmentValues()
        let defaultTheme = env.appTheme
        XCTAssertTrue(defaultTheme.colors is AppTheme.Type)
        env.appTheme = defaultTheme
        XCTAssertTrue(env.appTheme.typography is AppTypography.Type)
    }
}
