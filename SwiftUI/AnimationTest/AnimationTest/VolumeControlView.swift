//
//  VolumeControlView.swift
//  AnimationTest
//
//  Created by Rishik Dev on 16/07/24.
//

import SwiftUI

struct VolumeControlView: View {
    @State private var volumeLevel: Float = 0.75
    var body: some View {
        HStack {
            Image(systemName: "speaker.slash.fill")
            Slider(value: $volumeLevel, in: 0...1)
            Image(systemName: "speaker.3.fill")
        }
        .font(.caption)
    }
}


#Preview {
    VolumeControlView()
}
