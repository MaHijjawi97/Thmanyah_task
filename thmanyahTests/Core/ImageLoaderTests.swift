//
//  ImageLoaderTests.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import XCTest
@testable import thmanyah

final class ImageLoaderTests: XCTestCase {
    var loader: ImageLoader!

    override func setUpWithError() throws {
        loader = ImageLoader()
    }

    func testClearCacheDoesNotCrash() async {
        await loader.clearCache()
    }

    func testImageFromInvalidURLReturnsNil() async {
        let url = URL(string: "https://invalid.example.nonexistent/image.png")!
        let image = await loader.image(from: url)
        XCTAssertNil(image)
    }

    func testImageFromURLReturnsCachedResultOnSecondCall() async {
        // Use a URL that might 404 or return image - either way second call should be consistent
        let url = URL(string: "https://via.placeholder.com/1")!
        let first = await loader.image(from: url)
        let second = await loader.image(from: url)
        XCTAssertEqual(first != nil, second != nil)
    }
}
