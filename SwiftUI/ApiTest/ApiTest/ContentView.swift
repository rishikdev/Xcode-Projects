//
//  ContentView.swift
//  ApiTest
//
//  Created by Rishik Dev on 23/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var switchGamesVM = SwitchGamesViewModel(networkManager: NetworkManager.shared)
    
    var body: some View {
        ScrollView {
            ForEach(switchGamesVM.switchGames, id: \.id) { game in
                VStack {
                    Text(game.name)
                        .fontWeight(.bold)
                    
                    
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                try await switchGamesVM.getSwitchGames()
            }
        }
    }
}

#Preview {
    ContentView()
}
