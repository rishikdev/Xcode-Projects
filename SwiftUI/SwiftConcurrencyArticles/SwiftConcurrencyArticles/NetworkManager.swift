//
//  NetworkManager.swift
//  SwiftConcurrencyArticles
//
//  Created by Rishik Dev on 03/02/2025.
//

import Foundation

protocol NetworkManagerProtocol
{
    func fetchPosts(from urlString: String) async throws -> [PostModel]
}

actor NetworkManager: NetworkManagerProtocol
{
    static let shared = NetworkManager()
    private init() { }
    
    func fetchPosts(from urlString: String) async throws -> [PostModel]
    {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        do
        {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else
            {
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            let posts = try decoder.decode([PostModel].self, from: data)
            
            return posts
        }
        
        catch
        {
            throw error
        }
    }
}
