//
//  ThemeManager.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//  direct AppTheme / AppTypography usage.
//

import SwiftUI

/// Environment key for optional theme overrides (e.g. for tests or future light mode).
struct ThemeKey: EnvironmentKey {
    static let defaultValue: AppThemeValues = .default
}

struct AppThemeValues {
    var colors: AppTheme.Type { AppTheme.self }
    var typography: AppTypography.Type { AppTypography.self }
    static let `default` = AppThemeValues()
}

extension EnvironmentValues {
    var appTheme: AppThemeValues {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// MARK: - View modifiers for consistent styling

extension View {
    /// Applies app background and ignores safe area for full-bleed dark background.
    func appBackground() -> some View {
        self.background(AppTheme.background.ignoresSafeArea())
    }

    /// Primary text color
    func appTextPrimary() -> some View {
        self.foregroundStyle(AppTheme.textPrimary)
    }

    /// Secondary text color
    func appTextSecondary() -> some View {
        self.foregroundStyle(AppTheme.textSecondary)
    }

    /// Accent (yellow) for buttons and highlights
    func appAccent() -> some View {
        self.foregroundStyle(AppTheme.accent)
    }
}
