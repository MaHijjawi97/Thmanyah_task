//
//  APIClient.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 09/03/2026.
//  Generic networking client using URLSession, async/await, and Decodable.
//  Supports cancellation and HTTP status validation.
//  Debug logging for request URL and response (body + status) when DEBUG.
//

import Foundation

/// Errors that can occur during API requests.
enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, data: Data?)
    case decodingError(Error)
    case cancelled
}

/// Protocol for the API client to enable mocking in tests.
protocol APIClientProtocol: Sendable {
    func request<T: Decodable>(url: URL) async throws -> T
}

/// Generic API client using URLSession with async/await.
final class APIClient: APIClientProtocol, @unchecked Sendable {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Propagate current language (e.g. "en", "ar-SA") to backend.
        if let languageCode = Locale.preferredLanguages.first {
            request.setValue(languageCode, forHTTPHeaderField: "Accept-Language")
        }

        #if DEBUG
        debugPrint("[API] REQUEST: \(url.absoluteString)")
        #endif

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            #if DEBUG
            debugPrint("[API] NETWORK ERROR: \(error)")
            #endif
            if (error as NSError).code == NSURLErrorCancelled {
                throw APIError.cancelled
            }
            throw error
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        #if DEBUG
        let fullBody = String(data: data, encoding: .utf8) ?? "<non-UTF8>"
        debugPrint("[API] RESPONSE: status=\(httpResponse.statusCode) url=\(url.absoluteString)")
        debugPrint("[API] RESPONSE BODY (full): \(fullBody)")
        #endif

        guard (200...299).contains(httpResponse.statusCode) else {
            #if DEBUG
            debugPrint("[API] HTTP ERROR: status=\(httpResponse.statusCode)")
            #endif
            throw APIError.httpError(statusCode: httpResponse.statusCode, data: data)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            #if DEBUG
            debugPrint("[API] DECODING ERROR: \(error)")
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .typeMismatch(let type, let context):
                    debugPrint("[API] TYPE MISMATCH: expected \(type) at \(context.codingPath.map(\.stringValue).joined(separator: ".")) - \(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    debugPrint("[API] KEY NOT FOUND: \(key.stringValue) at \(context.codingPath.map(\.stringValue).joined(separator: "."))")
                case .valueNotFound(let type, let context):
                    debugPrint("[API] VALUE NOT FOUND: \(type) at \(context.codingPath.map(\.stringValue).joined(separator: "."))")
                case .dataCorrupted(let context):
                    debugPrint("[API] DATA CORRUPTED: \(context.debugDescription)")
                @unknown default:
                    break
                }
            }
            #endif
            throw APIError.decodingError(error)
        }
    }
}
