//
//  EndpointTests.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import XCTest
@testable import thmanyah

final class EndpointTests: XCTestCase {
    func testHomeSectionsPage1HasNoQueryItem() {
        let url = Endpoint.homeSections(page: 1)
        XCTAssertTrue(url.absoluteString.contains("home_sections"))
        XCTAssertNil(URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems)
    }

    func testHomeSectionsPage2HasPageQuery() {
        let url = Endpoint.homeSections(page: 2)
        let comp = URLComponents(url: url, resolvingAgainstBaseURL: false)
        XCTAssertEqual(comp?.queryItems?.first(where: { $0.name == "page" })?.value, "2")
    }

    func testSearchURLContainsQueryParameter() {
        let url = Endpoint.search(query: "hello world")
        XCTAssertTrue(url.absoluteString.contains("search"))
        let comp = URLComponents(url: url, resolvingAgainstBaseURL: false)
        XCTAssertEqual(comp?.queryItems?.first(where: { $0.name == "q" })?.value, "hello world")
    }
}
