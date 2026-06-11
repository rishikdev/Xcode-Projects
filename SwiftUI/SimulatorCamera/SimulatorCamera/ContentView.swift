//
//  ContentView.swift
//  SimulatorCamera
//
//  Created by Rishik Dev on 11/06/26.
//

import SwiftUI

struct ContentView: View {
    let cameraServer: CameraServer
    
    var body: some View {
        Text(cameraServer.statusMessage)
            .disabled(true)
        
        Divider()
        
        Button("Quit Simulator Camera", role: .destructive) {
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q")
    }
}

#Preview {
    ContentView(cameraServer: CameraServer())
}
