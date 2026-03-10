//
//  AppTheme.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import SwiftUI
import UIKit

// MARK: - Colors

struct AppTheme {
    /// Primary background (black / near-black)
    static let background = Color(hex: "#000000")
    /// Slightly lighter for cards or grouped areas
    static let backgroundSecondary = Color(hex: "#141414")
    /// Mini-player / elevated surface (dark warm brown)
    static let surfaceElevated = Color(hex: "#2C2520")

    /// Primary accent (yellow/gold) – buttons, play icons, selected state
    static let accent = Color(hex: "#FFC107")
    /// Slightly brighter accent for highlights
    static let accentBright = Color(hex: "#FFC800")

    /// Primary text (white)
    static let textPrimary = Color.white
    /// Secondary text (light gray)
    static let textSecondary = Color(hex: "#AAAAAA")
    /// Tertiary / placeholder
    static let textTertiary = Color(hex: "#888888")

    /// Progress bar played portion
    static let progressPlayed = Color(hex: "#FFC107")
    /// Progress bar unplayed
    static let progressUnplayed = Color(hex: "#3D3630")
}

// MARK: - Color hex helper (string-based "#RRGGBB" or "#RRGGBBAA")

extension Color {
    init(hex: String) {
        let cleaned = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        var int: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&int)

        let r, g, b, a: Double
        switch cleaned.count {
        case 8: // RRGGBBAA
            r = Double((int & 0xFF00_0000) >> 24) / 255.0
            g = Double((int & 0x00FF_0000) >> 16) / 255.0
            b = Double((int & 0x0000_FF00) >> 8) / 255.0
            a = Double(int & 0x0000_00FF) / 255.0
        case 6: // RRGGBB
            r = Double((int & 0xFF00_00) >> 16) / 255.0
            g = Double((int & 0x00FF_00) >> 8) / 255.0
            b = Double(int & 0x0000_FF) / 255.0
            a = 1.0
        default:
            r = 1; g = 1; b = 1; a = 1 // fallback to white for invalid input
        }

        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}

// MARK: - UIKit equivalents

extension UIColor {
    convenience init(hex: String) {
        let cleaned = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        var int: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&int)

        let r, g, b, a: CGFloat
        switch cleaned.count {
        case 8: // RRGGBBAA
            r = CGFloat((int & 0xFF00_0000) >> 24) / 255.0
            g = CGFloat((int & 0x00FF_0000) >> 16) / 255.0
            b = CGFloat((int & 0x0000_FF00) >> 8) / 255.0
            a = CGFloat(int & 0x0000_00FF) / 255.0
        case 6: // RRGGBB
            r = CGFloat((int & 0xFF00_00) >> 16) / 255.0
            g = CGFloat((int & 0x00FF_00) >> 8) / 255.0
            b = CGFloat(int & 0x0000_FF) / 255.0
            a = 1.0
        default:
            r = 1; g = 1; b = 1; a = 1
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }

    static let appBackground = UIColor(hex: "#000000")
    static let appBackgroundSecondary = UIColor(hex: "#141414")
    static let appAccent = UIColor(hex: "#FFC107")
    static let appTextPrimary = UIColor.white
    static let appTextSecondary = UIColor(hex: "#AAAAAA")
}
