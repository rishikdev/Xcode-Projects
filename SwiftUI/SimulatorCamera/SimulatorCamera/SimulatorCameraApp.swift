//
//  SimulatorCameraApp.swift
//  SimulatorCamera
//
//  Created by Rishik Dev on 11/06/26.
//

import SwiftUI

@main
struct SimulatorCameraApp: App {
    @State private var cameraServer = CameraServer()
    
    var body: some Scene {
        MenuBarExtra("Simulator Camera", systemImage: "web.camera") {
            ContentView(cameraServer: cameraServer)
        }
    }
}
