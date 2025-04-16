//
//  DashboardView.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Dashboard")
            }
            .navigationTitle(Constants.ViewTitle.dashboard.rawValue.key)
        }
        
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
}
