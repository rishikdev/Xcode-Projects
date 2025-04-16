//
//  HomeView.swift
//  AnimationTest
//
//  Created by Rishik Dev on 16/07/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                CassetteView()
                CassettePlayerView()
            }
            .navigationTitle("Player")
        }
    }
}

#Preview {
    HomeView()
}
