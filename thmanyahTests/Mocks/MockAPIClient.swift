//
//  MockAPIClient.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import Foundation
@testable import thmanyah

final class MockAPIClient: APIClientProtocol {
    var lastURL: URL?
    var responseData: Data?
    var errorToThrow: Error?
    private let decoder = JSONDecoder()

    func request<T: Decodable>(url: URL) async throws -> T {
        lastURL = url
        if let error = errorToThrow { throw error }
        guard let data = responseData else { throw NSError(domain: "MockAPIClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "No responseData set"]) }
        return try decoder.decode(T.self, from: data)
    }
}
