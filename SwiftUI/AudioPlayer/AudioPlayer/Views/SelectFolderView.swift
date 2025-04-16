//
//  SelectFolderView.swift
//  AudioPlayer
//
//  Created by Rishik Dev on 11/07/24.
//

import SwiftUI

struct SelectFolderView: View {
    var body: some View {
        Text("Please select a folder")
            .padding()
            .foregroundStyle(.gray)
            .font(.largeTitle)
            .fontWeight(.black)
            .fontDesign(.rounded)
    }
}

#Preview {
    SelectFolderView()
}
