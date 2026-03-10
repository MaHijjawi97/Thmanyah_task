//
//  ImageLoader.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//  Actor-based image loader with in-memory caching.
//

import UIKit

actor ImageLoader {
    private var cache: [URL: UIImage] = [:]
    private var loadingTasks: [URL: Task<UIImage?, Never>] = [:]

    func image(from url: URL) async -> UIImage? {
        if let cached = cache[url] {
            return cached
        }
        if let existing = loadingTasks[url] {
            return await existing.value
        }
        let task = Task<UIImage?, Never> {
            await load(url: url)
        }
        loadingTasks[url] = task
        let image = await task.value
        loadingTasks[url] = nil
        if let image = image {
            cache[url] = image
        }
        return image
    }

    private func load(url: URL) async -> UIImage? {
        guard let (data, _) = try? await URLSession.shared.data(from: url),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }

    func clearCache() {
        cache.removeAll()
    }
}
