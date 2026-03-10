//
//  AppTypography.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import SwiftUI
import UIKit

/// Font names as registered in the app bundle (UIAppFonts). Match the OTF PostScript/full names.
private enum AppFontName {
    static let regular = "IBMPlexSansArabic-Regular"
    static let text = "IBMPlexSansArabic-Text"
    static let medium = "IBMPlexSansArabic-Medium"
    static let semiBold = "IBMPlexSansArabic-SemiBold"
    static let bold = "IBMPlexSansArabic-Bold"
    static let light = "IBMPlexSansArabic-Light"
}

enum AppTypography {
    /// Large section titles (e.g. "Queue", "Hear it first")
    static var sectionTitle: Font { .custom(AppFontName.bold, size: 22) }

    /// Card titles and content headings
    static var title: Font { .custom(AppFontName.semiBold, size: 17) }

    /// Body text
    static var body: Font { .custom(AppFontName.regular, size: 15) }

    /// Secondary labels (dates, counts)
    static var caption: Font { .custom(AppFontName.regular, size: 13) }

    /// Small labels (duration, badges)
    static var caption2: Font { .custom(AppFontName.medium, size: 11) }
}

// MARK: - UIKit (with fallback when custom font not loaded)

extension UIFont {
    private static func appFont(name: String, size: CGFloat, fallbackWeight: UIFont.Weight = .regular) -> UIFont {
        UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: fallbackWeight)
    }

    static let appSectionTitle = UIFont.appFont(name: AppFontName.bold, size: 22, fallbackWeight: .bold)
    static let appTitle = UIFont.appFont(name: AppFontName.semiBold, size: 17, fallbackWeight: .semibold)
    static let appBody = UIFont.appFont(name: AppFontName.regular, size: 15, fallbackWeight: .regular)
    static let appCaption = UIFont.appFont(name: AppFontName.regular, size: 13, fallbackWeight: .regular)
    static let appCaption2 = UIFont.appFont(name: AppFontName.medium, size: 11, fallbackWeight: .medium)
}
