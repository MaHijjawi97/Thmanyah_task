//
//  AppTypographyTests.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//


import SwiftUI
import UIKit
import XCTest
@testable import thmanyah

final class AppTypographyTests: XCTestCase {
    func testSectionTitleFontIsCustom() {
        _ = AppTypography.sectionTitle
    }

    func testTitleFontIsCustom() {
        _ = AppTypography.title
    }

    func testBodyFontIsCustom() {
        _ = AppTypography.body
    }

    func testCaptionFontIsCustom() {
        _ = AppTypography.caption
    }

    func testCaption2FontIsCustom() {
        _ = AppTypography.caption2
    }

    func testUIFontAppSectionTitleHasSize() {
        let font = UIFont.appSectionTitle
        XCTAssertEqual(font.pointSize, 22)
    }

    func testUIFontAppTitleHasSize() {
        XCTAssertEqual(UIFont.appTitle.pointSize, 17)
    }

    func testUIFontAppBodyHasSize() {
        XCTAssertEqual(UIFont.appBody.pointSize, 15)
    }

    func testUIFontAppCaptionHasSize() {
        XCTAssertEqual(UIFont.appCaption.pointSize, 13)
    }

    func testUIFontAppCaption2HasSize() {
        XCTAssertEqual(UIFont.appCaption2.pointSize, 11)
    }
}
