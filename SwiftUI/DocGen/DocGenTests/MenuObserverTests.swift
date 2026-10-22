//
//  MenuObserverTests.swift
//  DocGen
//
//  Created by Rishik Dev on 21/10/26.
//

import AppKit
import Testing
@testable import DocGen

@Suite("Menu Observer Tests")
@MainActor
struct MenuObserverTests {

    @Test("Initial state has isMenuOpen set to false")
    func initialStateIsMenuOpenFalse() {
        let observer = MenuObserver()
        #expect(!observer.isMenuOpen)
    }

    @Test("Observes NSMenu didBeginTrackingNotification and didEndTrackingNotification")
    func respondsToMenuTrackingNotifications() async throws {
        let observer = MenuObserver()

        // Allow async tasks in MenuObserver init to register for notifications
        try await Task.sleep(for: .milliseconds(50))

        NotificationCenter.default.post(
            name: NSMenu.didBeginTrackingNotification,
            object: nil
        )

        try await Task.sleep(for: .milliseconds(50))
        #expect(observer.isMenuOpen)

        NotificationCenter.default.post(
            name: NSMenu.didEndTrackingNotification,
            object: nil
        )

        try await Task.sleep(for: .milliseconds(50))
        #expect(!observer.isMenuOpen)
    }
}
