//
//  Endpoint.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 09/03/2026.
//

import Foundation

enum Endpoint {
    static let baseHome = URL(string: "https://api-v2-b2sit6oh3a-uc.a.run.app")!
    static let baseSearch = URL(string: "https://mock.apidog.com/m1/735111-711675-default")!

    static func homeSections(page: Int = 1) -> URL {
        var components = URLComponents(url: baseHome.appendingPathComponent("home_sections"), resolvingAgainstBaseURL: false)!
        if page > 1 {
            components.queryItems = [URLQueryItem(name: "page", value: String(page))]
        }
        return components.url ?? baseHome.appendingPathComponent("home_sections")
    }

    static func search(query: String) -> URL {
        var components = URLComponents(url: baseSearch.appendingPathComponent("search"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "q", value: query)]
        return components.url ?? baseSearch.appendingPathComponent("search")
    }
}
