//
//  SwitchGamesViewModel.swift
//  ApiTest
//
//  Created by Rishik Dev on 23/10/23.
//

import Foundation

class SwitchGamesViewModel: ObservableObject {
    @Published var switchGames: [SwitchGame] = []
    
    var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getSwitchGames() async throws {
        self.switchGames = try await networkManager.getSwitchGames()
    }
}
