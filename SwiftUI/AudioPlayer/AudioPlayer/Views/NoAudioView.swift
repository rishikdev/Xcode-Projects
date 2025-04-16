//
//  NoAudioView.swift
//  AudioPlayer
//
//  Created by Rishik Dev on 12/07/24.
//

import SwiftUI

struct NoAudioView: View {
    var folderName: String
    
    var body: some View {
        Group {
            Text("Folder ")
            + Text(folderName)
                .foregroundStyle(.red)
            + Text(" does not contain any audio file!")
        }
        .padding()
        .foregroundStyle(.gray)
        .font(.largeTitle)
        .fontWeight(.black)
        .fontDesign(.rounded)
    }
}

#Preview {
    NoAudioView(folderName: "Demo Folder")
}
