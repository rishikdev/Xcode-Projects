//
//  PickleballApp.swift
//  Pickleball
//
//  Created by Rishik Dev on 05/11/24.
//

import SwiftUI

@main
struct PickleballApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ControllerView()
        }
    }
}
