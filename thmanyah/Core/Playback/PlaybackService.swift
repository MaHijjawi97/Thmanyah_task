//
//  PlaybackService.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 09/03/2026.
//  Handles audio and video playback. When API returns audio_url and/or video_url,
//  play in audio mode (background-friendly) or switch to video when user chooses.

import AVFoundation
import Combine
import Foundation

@MainActor
final class PlaybackService: ObservableObject {
    enum Mode {
        case audio
        case video
    }

    @Published private(set) var currentItem: SectionItem?
    @Published private(set) var isPlaying = false
    @Published private(set) var currentTime: TimeInterval = 0
    @Published private(set) var duration: TimeInterval = 0
    @Published var mode: Mode = .audio

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()

    var hasContent: Bool { currentItem != nil }
    var canSwitchToVideo: Bool { currentItem?.videoURL != nil }
    var canSwitchToAudio: Bool { currentItem?.audioURL != nil }

    #if DEBUG
    /// Helper for SwiftUI previews to seed the service with a demo item.
    static func preview(with item: SectionItem, currentTime: TimeInterval = 0) -> PlaybackService {
        let service = PlaybackService()
        service.currentItem = item
        service.duration = item.durationSeconds.map { TimeInterval($0) } ?? 0
        service.currentTime = min(max(0, currentTime), service.duration)
        return service
    }
    #endif

    func play(_ item: SectionItem) {
        let url: URL?
        switch mode {
        case .audio: url = item.audioURL ?? item.videoURL
        case .video: url = item.videoURL ?? item.audioURL
        }
        guard let playURL = url else { return }

        if currentItem?.id == item.id, let p = player {
            p.play()
            isPlaying = true
            return
        }

        stop()
        let playerItem = AVPlayerItem(url: playURL)
        let newPlayer = AVPlayer(playerItem: playerItem)
        newPlayer.actionAtItemEnd = .pause
        player = newPlayer
        currentItem = item
        duration = item.durationSeconds.map { TimeInterval($0) } ?? 0
        if duration <= 0 {
            Task { await updateDurationFromPlayer() }
        }

        addTimeObserver(to: newPlayer)
        newPlayer.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func togglePlayPause() {
        if isPlaying { pause() } else { resume() }
    }

    func resume() {
        guard player != nil else { return }
        player?.play()
        isPlaying = true
    }

    func stop() {
        removeTimeObserver()
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        currentItem = nil
        currentTime = 0
        duration = 0
        isPlaying = false
    }

    func seek(seconds: Double) {
        guard let p = player else { return }
        let t = max(0, min(currentTime + seconds, duration))
        p.seek(to: CMTime(seconds: t, preferredTimescale: 600)) { [weak self] _ in
            Task { @MainActor in
                self?.currentTime = t
            }
        }
    }

    func seekToProgress(_ progress: Double) {
        guard let p = player, duration > 0 else { return }
        let t = max(0, min(progress * duration, duration))
        p.seek(to: CMTime(seconds: t, preferredTimescale: 600))
        currentTime = t
    }

    func switchToVideo() {
        guard canSwitchToVideo, let item = currentItem, let url = item.videoURL else { return }
        mode = .video
        let playerItem = AVPlayerItem(url: url)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
        isPlaying = true
    }

    func switchToAudio() {
        guard canSwitchToAudio, let item = currentItem, let url = item.audioURL else { return }
        mode = .audio
        let playerItem = AVPlayerItem(url: url)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
        isPlaying = true
    }

    private func addTimeObserver(to p: AVPlayer) {
        removeTimeObserver()
        timeObserver = p.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
        }
    }

    private func removeTimeObserver() {
        if let o = timeObserver, let p = player {
            p.removeTimeObserver(o)
        }
        timeObserver = nil
    }

    private func updateDurationFromPlayer() async {
        guard let p = player else { return }
        guard let item = p.currentItem else { return }
        while item.status != .readyToPlay && item.status != .failed {
            try? await Task.sleep(nanoseconds: 100_000_000)
        }
        let d = item.asset.duration.seconds
        if d.isFinite && d > 0 {
            await MainActor.run { duration = d }
        }
    }
}
