//
//  CassettePlayerView.swift
//  AnimationTest
//
//  Created by Rishik Dev on 16/07/24.
//

import SwiftUI

struct CassettePlayerView: View {
    @State private var backwardClicked: Bool = false
    @State private var isPlaying: Bool = false
    @State private var forwardClicked: Bool = false
    @State private var isRepeating: Bool = false
    @State private var shuffleClicked: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressBarView()
            Divider()
            PlayControlsView(shuffleClicked: $shuffleClicked, buttons: [AnyView(backwardButton), AnyView(playButton), AnyView(forwardButton), AnyView(repeatButton), AnyView(shuffleButton)])
            Divider()
            VolumeControlView()
        }
        .padding()
        .background(.thinMaterial.shadow(.inner(radius: 10)))
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .padding()
        .onChange(of: shuffleClicked) {
            withAnimation {
                self.shuffleClicked.toggle()
            }
        }
    }
    
    private var backwardButton: some View {
        Button(action: {
            self.backwardClicked.toggle()
        }, label: {
            Image(systemName: "backward.fill")
                .symbolEffect(.bounce, value: backwardClicked)
        })
    }
    
    private var playButton: some View {
        Button(action: {
            self.isPlaying.toggle()
        }, label: {
            Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
                .imageScale(.large)
        })
        .contentTransition(.symbolEffect(.replace))
        .font(.largeTitle)
        .frame(minWidth: 50, minHeight: 50)
    }
    
    private var forwardButton: some View {
        Button(action: {
            self.forwardClicked.toggle()
        }, label: {
            Image(systemName: "forward.fill")
                .symbolEffect(.bounce, value: forwardClicked)
        })
    }
    
    private var repeatButton: some View {
        Toggle(isOn: $isRepeating, label: {
            Image(systemName: "repeat")
                .symbolEffect(.bounce, value: isRepeating)
        })
        .toggleStyle(.button)
    }
    
    private var shuffleButton: some View {
        Button(action: {
            withAnimation {
                self.shuffleClicked.toggle()
            }
            
        }, label: {
            Image(systemName: "shuffle")
                .symbolEffect(.bounce, value: shuffleClicked)
        })
    }
}

#Preview {
    CassettePlayerView()
}
