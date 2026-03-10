//
//  SearchRepositoryProtocol.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import Foundation

protocol SearchRepositoryProtocol: Sendable {
    func search(query: String) async throws -> [Section]
}
