//
//  HomeAPI.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 09/03/2026.
//
import Foundation

struct HomeAPI {
    let apiClient: APIClientProtocol

    func fetchHomeSections(page: Int) async throws -> HomeResponseDTO {
        let url = Endpoint.homeSections(page: page)
        return try await apiClient.request(url: url)
    }
}
