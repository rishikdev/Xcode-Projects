//
//  NetworkManager.swift
//  ApiTest
//
//  Created by Rishik Dev on 23/10/23.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func getSwitchGames() async throws -> [SwitchGame] {
        guard let url = URL(string: "https://api.sampleapis.com/switch/games") else { throw FetchError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw FetchError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([SwitchGame].self, from: data)
        } catch {
            print("Error Fetching: \(error)")
            throw error
        }
    }
}

enum FetchError: String, Error {
    case invalidURL = "Invalid URL"
    case invalidResponse = "Invalid Response"
}
