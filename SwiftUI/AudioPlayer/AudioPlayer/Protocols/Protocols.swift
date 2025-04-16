//
//  Protocols.swift
//  AudioPlayer
//
//  Created by Rishik Dev on 10/07/24.
//

import Foundation
import AVFoundation

protocol PlayerHandlerProtocol {
    var avPlayer: AVPlayer { get set }
    func startPlayingAudioFile(path: URL) -> Result<Bool, Error>
    func pausePlayingAudioFile()
    func stopPlayingAudioFile()
    func seek(to timeInterval: TimeInterval) async
    func setVolume(to value: Float)
}

protocol FileHandlerProtocol {
    func openFolder(path: URL) -> Result<[URL], Error>
    func loadFiles(paths: [URL]) -> Result<[AudioModel], Error>
    func storeAudioFile(audioFile: AudioModel) -> Result<Bool, Error>
}
