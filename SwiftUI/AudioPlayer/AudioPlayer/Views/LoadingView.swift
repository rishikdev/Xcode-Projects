//
//  LoadingView.swift
//  AudioPlayer
//
//  Created by Rishik Dev on 11/07/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            
            Text("Loading")
                .foregroundStyle(.gray)
                .padding(.top)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    LoadingView()
}
