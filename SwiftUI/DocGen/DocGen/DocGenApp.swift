//
//  DocGenApp.swift
//  DocGen
//
//  Created by Rishik Dev on 05/10/26.
//

import SwiftUI

@main
struct DocGenApp: App {
    var body: some Scene {
        MenuBarExtra("DocGen", systemImage: "text.document") {
            ContentView()
        }
        .menuBarExtraStyle(.menu)
    }
}
