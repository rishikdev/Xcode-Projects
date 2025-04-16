//
//  HomeView.swift
//  Pickleball
//
//  Created by Rishik Dev on 05/11/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label(Constants.ViewTitle.dashboard.rawValue.key,
                          systemImage: "square.grid.2x2.fill")
                }
                .tag(0)
            
            TournamentsView()
                .tabItem {
                    Label(Constants.ViewTitle.tournaments.rawValue.key,
                          systemImage: "trophy.fill")
                }
                .tag(1)
            
            ClubsView()
                .tabItem {
                    Label(Constants.ViewTitle.clubs.rawValue.key,
                          systemImage: "globe")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label(Constants.ViewTitle.settings.rawValue.key,
                          systemImage: "gear")
                }
                .tag(3)
        }
    }
}

#Preview {
        HomeView()
            .environmentObject(AuthenticationViewModel())
}
