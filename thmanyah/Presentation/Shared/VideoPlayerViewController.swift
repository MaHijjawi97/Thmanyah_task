//
//  VideoPlayerViewController.swift
//  thmanyah
//
//  Created by MohammadHijjawi on 08/03/2026.
//

import AVKit
import SwiftUI
import UIKit

struct VideoPlayerViewController: UIViewControllerRepresentable {
    let url: URL
    @ObservedObject var playback: PlaybackService

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let vc = AVPlayerViewController()
        vc.player = AVPlayer(url: url)
        vc.player?.play()
        return vc
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}
