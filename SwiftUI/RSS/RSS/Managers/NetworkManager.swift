//
//  NetworkManager.swift
//  RSS
//
//  Created by Rishik Dev on 25/02/2025.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchFeedItems(from urlString: String) async throws -> Data
    func fetchMockFeedItems(from urlString: String) async throws -> Data
}

actor NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private init() { }
    
    func fetchFeedItems(from urlString: String) async throws -> Data {
        do {
            if let url = URL(string: urlString) {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode >= 200 && httpResponse.statusCode <= 300 {
                    return data
                }
                
                throw URLError(.badServerResponse)
                
            } else {
                throw RSSError.invalidURL
            }
        } catch {
            throw error
        }
    }
    
    func fetchMockFeedItems(from urlString: String) async throws -> Data {
        do {
            guard let path = Bundle.main.path(forResource: urlString, ofType: "xml") else {
                throw RSSError.invalidURL
            }
            
            let url = URL(fileURLWithPath: path)
            
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
}
