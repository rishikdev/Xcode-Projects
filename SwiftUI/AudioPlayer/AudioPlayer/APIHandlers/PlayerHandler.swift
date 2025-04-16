//
//  PlayerHandler.swift
//  AudioPlayer
//
//  Created by Rishik Dev on 10/07/24.
//

import Foundation
import AVFoundation
import Combine
#if os(iOS)
import UIKit
#endif
import MediaPlayer

class PlayerHandler: PlayerHandlerProtocol {
    var avPlayer: AVPlayer
    
    private var subscriptions: Set<AnyCancellable> = []
    private var timeObserverToken: Any?
    
    private init() {
        avPlayer = AVPlayer()
    }
    static var shared = PlayerHandler()
    
    func startPlayingAudioFile(path: URL) -> Result<Bool, Error> {
        var hasError: Bool = false
        let asset = AVAsset(url: path)
        let playerItem = AVPlayerItem(
            asset: asset,
            automaticallyLoadedAssetKeys: [.tracks, .duration, .commonMetadata]
        )
        // Register to observe the status property before associating with player.
        playerItem.publisher(for: \.status)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                switch status {
                case .readyToPlay:
                    avPlayer.play()
                case .failed:
                    hasError = true
                default:
                    break
                }
            }
            .store(in: &subscriptions)
        
        // Set the item as the player's current item.
        avPlayer.replaceCurrentItem(with: playerItem)
        
        if hasError {
            return .failure(AudioError.AVSessionError)
        } else {
            return .success(true)
        }
    }
    
    func pausePlayingAudioFile() {
        avPlayer.pause()
    }
    
    func stopPlayingAudioFile() {
        avPlayer.pause()
        
        // Seek to the beginning
        avPlayer.seek(to: .zero)
        
        // Optionally, remove the player item to clear the player
        avPlayer.replaceCurrentItem(with: nil)
    }
    
    func seek(to timeInterval: TimeInterval) async {
        // Create a CMTime value for the passed in time interval.
        let time = CMTime(seconds: timeInterval, preferredTimescale: 600)
        await avPlayer.seek(to: time)
    }
    
    func setVolume(to value: Float) {
        avPlayer.volume = value
        #if os(iOS)
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = value
        }
        #endif
    }
}
