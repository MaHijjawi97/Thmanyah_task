//
//  HomeRepositoryProtocol.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import Foundation

protocol HomeRepositoryProtocol: Sendable {
    func fetchSections(page: Int) async throws -> (sections: [Section], nextPage: Int?)
}
