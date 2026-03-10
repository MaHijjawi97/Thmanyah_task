//
//  PlaybackServiceTests.swift
//  thmanyahTests
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import XCTest
@testable import thmanyah

@MainActor
final class PlaybackServiceTests: XCTestCase {
    var service: PlaybackService!

    override func setUpWithError() throws {
        service = PlaybackService()
    }

    func testInitialStateHasNoContent() {
        XCTAssertFalse(service.hasContent)
        XCTAssertFalse(service.canSwitchToVideo)
        XCTAssertFalse(service.canSwitchToAudio)
        XCTAssertFalse(service.isPlaying)
        XCTAssertEqual(service.currentTime, 0)
        XCTAssertEqual(service.duration, 0)
    }

    func testStopWhenIdleIsNoOp() {
        service.stop()
        XCTAssertFalse(service.hasContent)
        XCTAssertFalse(service.isPlaying)
    }

    func testPauseWhenNotPlayingSetsIsPlayingFalse() {
        service.pause()
        XCTAssertFalse(service.isPlaying)
    }

    func testResumeWhenNoPlayerDoesNothing() {
        service.resume()
        XCTAssertFalse(service.isPlaying)
    }

    func testSeekWhenNoPlayerDoesNothing() {
        service.seek(seconds: 10)
        XCTAssertEqual(service.currentTime, 0)
    }

    func testSeekToProgressWhenNoPlayerDoesNothing() {
        service.seekToProgress(0.5)
        XCTAssertEqual(service.currentTime, 0)
    }

    func testSwitchToVideoWhenNoContentDoesNothing() {
        service.switchToVideo()
        XCTAssertEqual(service.mode, .audio)
    }

    func testSwitchToAudioWhenNoContentDoesNothing() {
        service.switchToAudio()
        XCTAssertEqual(service.mode, .audio)
    }

    func testTogglePlayPauseWhenNotPlayingCallsResume() {
        service.togglePlayPause()
        XCTAssertFalse(service.isPlaying)
    }

    func testModeDefaultsToAudio() {
        XCTAssertEqual(service.mode, .audio)
    }

    func testPlayItemWithNoAudioOrVideoURLDoesNothing() {
        let item = SectionItem.podcast(
            id: "1",
            name: "Pod",
            description: nil,
            avatarURL: nil,
            episodeCount: nil,
            duration: nil,
            audioURL: nil,
            videoURL: nil
        )
        service.play(item)
        XCTAssertFalse(service.hasContent)
    }

    func testPlayItemWithAudioURLSetsCurrentItemAndPlays() {
        let url = URL(string: "https://example.com/audio.mp3")!
        let item = SectionItem.podcast(
            id: "1",
            name: "Pod",
            description: nil,
            avatarURL: nil,
            episodeCount: nil,
            duration: nil,
            audioURL: url,
            videoURL: nil
        )
        service.play(item)
        XCTAssertTrue(service.hasContent)
        XCTAssertEqual(service.currentItem?.id, "1")
        XCTAssertTrue(service.isPlaying)
        service.stop()
        XCTAssertFalse(service.hasContent)
        XCTAssertFalse(service.isPlaying)
    }
}
