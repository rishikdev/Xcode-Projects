//
//  MenuObserver.swift
//  DocGen
//
//  Created by Rishik Dev on 06/10/26.
//

import SwiftUI

@Observable
@MainActor
final class MenuObserver {
    var isMenuOpen = false
    
    init() {
        Task { [weak self] in
            let openNotifications = NotificationCenter.default.notifications(named: NSMenu.didBeginTrackingNotification)
            
            for await _ in openNotifications {
                self?.isMenuOpen = true
            }
        }
        
        Task { [weak self] in
            let closeNotifications = NotificationCenter.default.notifications(named: NSMenu.didEndTrackingNotification)
            
            for await _ in closeNotifications {
                self?.isMenuOpen = false
            }
        }
    }
}
