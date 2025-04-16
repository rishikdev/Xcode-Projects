//
//  AudioListView.swift
//  AudioPlayer
//
//  Created by Rishik Dev on 11/07/24.
//

import SwiftUI

struct AudioListView: View {
    @ObservedObject var playerHandlerVM: FileAndPlayerHandlerViewModel
    
    var body: some View {
        List(playerHandlerVM.audioFiles, id: \.self.path) { audioFile in
            Text(audioFile.name)
                .lineLimit(1)
        }
    }
}

#Preview {
    AudioListView(playerHandlerVM: FileAndPlayerHandlerViewModel(fileHandler: FileHandler.shared, playerHandler: PlayerHandler.shared))
}
