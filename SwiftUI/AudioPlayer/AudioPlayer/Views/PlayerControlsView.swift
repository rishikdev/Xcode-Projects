//
//  PlayerControlsView.swift
//  AudioPlayer
//
//  Created by Rishik Dev on 11/07/24.
//

import SwiftUI
import AVFoundation

struct PlayerControlsView: View {
    @ObservedObject var fileAndPlayerHandlerVM: FileAndPlayerHandlerViewModel
    @State private var volumeLevel: Float = 0
    @State private var isPlaying: Bool = false
    @State private var isPlayingNext: Bool = false
    @State private var isPlayingPrevious: Bool = false
    
    var body: some View {
        VStack() {
            HStack {
                CurrentTimeText
                Spacer()
                ProgressView(value: fileAndPlayerHandlerVM.currentTime, total: fileAndPlayerHandlerVM.currentAudioFile?.duration ?? 0) {
                    Text(self.fileAndPlayerHandlerVM.currentAudioFile?.name ?? "Unknown")
                        .lineLimit(1)
                }
                    .progressViewStyle(.linear)
                Spacer()
                TotalTimeText
            }
            .font(.caption)
            
            Spacer()
            
            HStack() {
                PlayPreviousButton
                Spacer()
                PlayPauseButton
                Spacer()
                PlayNextButton
            }
            .font(.title2)
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 50)
            
            Spacer()
            
//            VolumeSlider
        }
        .padding()
    }
    
    private var CurrentTimeText: some View {
        Text(getDuration(seconds: fileAndPlayerHandlerVM.currentTime))
            .frame(minWidth: 50)
    }
    
    private var TotalTimeText: some View {
        Text(getDuration(seconds: fileAndPlayerHandlerVM.currentAudioFile?.duration ?? 0))
            .frame(minWidth: 50)
    }
    
    private var PlayPreviousButton: some View {
        Button {
            self.isPlayingPrevious.toggle()
            guard let previousAudioFile = fileAndPlayerHandlerVM.previousAudioFile else { return }
            
            if(isPlaying) {
                self.fileAndPlayerHandlerVM.startPlayingAudioFile(previousAudioFile)
            } else {
                self.fileAndPlayerHandlerVM.storeAudioFile(previousAudioFile)
            }
        } label: {
            Image(systemName: "backward.fill")
        }
        .symbolEffect(.bounce, value: isPlayingPrevious)
        .disabled(!self.fileAndPlayerHandlerVM.canPlayPrevious)
    }
    
    private var PlayPauseButton: some View {
        Button {
            if self.isPlaying {
                fileAndPlayerHandlerVM.pausePlayingAudioFile()
            } else {
                if let currentAudioFile = fileAndPlayerHandlerVM.currentAudioFile {
                    fileAndPlayerHandlerVM.startPlayingAudioFile(currentAudioFile)
                }
            }
            self.isPlaying.toggle()
        } label: {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
        }
        .contentTransition(.symbolEffect(.replace))
        .font(.largeTitle)
    }
    
    private var PlayNextButton: some View {
        Button {
            self.isPlayingNext.toggle()
            guard let nextAudioFile = fileAndPlayerHandlerVM.nextAudioFile else { return }
            
            if(isPlaying) {
                self.fileAndPlayerHandlerVM.startPlayingAudioFile(nextAudioFile)
            } else {
                self.fileAndPlayerHandlerVM.storeAudioFile(nextAudioFile)
            }
            
        } label: {
            Image(systemName: "forward.fill")
        }
        .symbolEffect(.bounce, value: isPlayingNext)
        .disabled(!self.fileAndPlayerHandlerVM.canPlayNext)
    }
    
    private var VolumeSlider: some View {
        HStack {
            Image(systemName: "speaker.wave.1.fill")
            Slider(value: $fileAndPlayerHandlerVM.volumeLevel, in: 0...1)
            Image(systemName: "speaker.wave.3.fill")
        }
        .onChange(of: fileAndPlayerHandlerVM.volumeLevel) {
            self.fileAndPlayerHandlerVM.setVolume(to: $fileAndPlayerHandlerVM.volumeLevel.wrappedValue)
        }
    }
        
    func getDuration(seconds: Double) -> String {
        let formatter = DateComponentsFormatter()
        if(seconds >= 3600) {
            formatter.allowedUnits = [.hour, .minute, .second]
        } else {
            formatter.allowedUnits = [.minute, .second]
        }
        
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        let duration = formatter.string(from: TimeInterval(seconds))!
        
        return duration
    }
}

#Preview {
    PlayerControlsView(fileAndPlayerHandlerVM: FileAndPlayerHandlerViewModel(fileHandler: FileHandler.shared, playerHandler: PlayerHandler.shared))
}
