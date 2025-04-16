//
//  FileAndPlayerHandlerViewModel.swift
//  AudioPlayer
//
//  Created by Rishik Dev on 10/07/24.
//

import Foundation
import AVFoundation
import MediaPlayer
import CoreAudio
import SwiftUI

class FileAndPlayerHandlerViewModel: ObservableObject {
    @Published var audioFiles: [AudioModel] = []
    @Published var currentAudioFile: AudioModel?
    @Published var errorEncountered: Bool = false
    @Published var errorMessage: String = ""
    @Published var currentTime: Double = 0
    @Published var volumeLevel: Float = 0
    @Published var canPlayPrevious: Bool = false
    @Published var canPlayNext: Bool = false
    @Published var previousAudioFile: AudioModel?
    @Published var nextAudioFile: AudioModel?
    
    private var timeObserverToken: Any?
    
    var fileHandler: FileHandlerProtocol
    var playerHandler: PlayerHandlerProtocol
    
    init(fileHandler: FileHandlerProtocol, playerHandler: PlayerHandlerProtocol) {
        self.fileHandler = fileHandler
        self.playerHandler = playerHandler
        self.getVolumeLevel()
    }
    
    func openFolder(path: URL) {
        let result = fileHandler.openFolder(path: path)
        
        switch result {
        case .success(let paths):
            loadFiles(paths: paths)
        case .failure(_):
            self.errorEncountered = true
            self.errorMessage = "Folder named \(path.lastPathComponent) could not be opened."
        }
    }
    
    func loadFiles(paths: [URL]) {
        let result = fileHandler.loadFiles(paths: paths)
        
        switch result {
        case .success(let audioFiles):
            self.audioFiles = audioFiles
            if(!audioFiles.isEmpty) {
                self.storeAudioFile(audioFiles[0])
                self.determinePreviousOrNextPlayability()
            }
            self.storeAudioFile(audioFiles[0])
        case .failure(let error):
            self.errorEncountered = true
            self.errorMessage = error.localizedDescription
        }
    }
    
    func storeAudioFile(_ audioFile: AudioModel) {
        let result = fileHandler.storeAudioFile(audioFile: audioFile)
        
        switch result {
        case .success(_):
            self.currentAudioFile = audioFile
            self.currentTime = 0
            self.determinePreviousOrNextPlayability()

        case .failure(let error):
            self.errorEncountered = true
            self.errorMessage = error.localizedDescription
        }
    }
    
    func determinePreviousOrNextPlayability() {
        let index = audioFiles.firstIndex {
            $0.path == currentAudioFile?.path
        }
        
        guard let index else { return }
        
        self.canPlayPrevious = index > 0
        self.canPlayNext = index < audioFiles.count - 1
        
        if(canPlayPrevious) {
            self.previousAudioFile = audioFiles[index - 1]
        }
        
        if(canPlayNext) {
            self.nextAudioFile = audioFiles[index + 1]
        }
    }
    
    func addPeriodicTimeObserver() {
        // Invoke callback every half second
        let interval = CMTime(seconds: 0.5,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        // Add time observer. Invoke closure on the main queue.
        timeObserverToken =
        playerHandler.avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] time in
            // update player transport UI
            guard let self else { return }
            self.currentTime = time.seconds
        }
    }
    
    func removePeriodicTimeObserver() {
        // If a time observer exists, remove it
        if let token = timeObserverToken {
            playerHandler.avPlayer.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    func startPlayingAudioFile(_ audioFile: AudioModel) {
        if(self.currentAudioFile != audioFile) {
            self.storeAudioFile(audioFile)
        }
        
        let result = playerHandler.startPlayingAudioFile(path: audioFile.path)
        self.addPeriodicTimeObserver()
        
        switch result {
        case .success(_):
            self.errorEncountered = false
            self.errorMessage = ""
        case .failure(let error):
            self.errorEncountered = true
            self.errorMessage = error.localizedDescription
        }
    }
    
    func pausePlayingAudioFile() {
        playerHandler.pausePlayingAudioFile()
    }
    
    func stopPlayingAudioFile() {
        playerHandler.stopPlayingAudioFile()
        self.currentAudioFile = nil
        self.removePeriodicTimeObserver()
        self.currentTime = 0
    }
    
    func getVolumeLevel() {
        #if os(iOS)
        let volumeView = MPVolumeView()
        if let volumeSlider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            self.volumeLevel = volumeSlider.value
        }
        self.volumeLevel = 0.0
        #endif
    }
    
    func setVolume(to value: Float) {
        self.playerHandler.setVolume(to: value)
    }
}
