//
//  LayoutType.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import Foundation

/// Section layout type from API. Normalizes "big square" (with space) to bigSquare.
enum LayoutType: String, Sendable {
    case square
    case bigSquare = "big_square"
    case twoLinesGrid = "2_lines_grid"
    case queue

    init?(rawValue: String) {
        let normalized = rawValue.replacingOccurrences(of: " ", with: "_").lowercased()
        switch normalized {
        case "square": self = .square
        case "big_square": self = .bigSquare
        case "2_lines_grid": self = .twoLinesGrid
        case "queue": self = .queue
        default: return nil
        }
    }
}
