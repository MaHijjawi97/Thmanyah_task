//
//  PlaybackEnvironment.swift
//  thmanyah
//  Created by MohammadHijjawi on 09/03/2026.
//

import SwiftUI

private struct PlaybackServiceKey: EnvironmentKey {
    @MainActor static let defaultValue: PlaybackService? = nil
}

extension EnvironmentValues {
    var playbackService: PlaybackService? {
        get { self[PlaybackServiceKey.self] }
        set { self[PlaybackServiceKey.self] = newValue }
    }
}
