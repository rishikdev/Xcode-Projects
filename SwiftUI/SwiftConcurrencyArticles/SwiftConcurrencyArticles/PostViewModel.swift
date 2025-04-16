//
//  PostViewModel.swift
//  SwiftConcurrencyArticles
//
//  Created by Rishik Dev on 03/02/2025.
//

import Foundation

enum PostsFetchStatus
{
    case reset, initiated, success, failure
}

class PostViewModel: ObservableObject
{
    @Published var posts: [PostModel] = []
    @Published var fetchStatus: PostsFetchStatus = .reset
    @Published var errorMessage: String = ""
    
    var networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol)
    {
        self.networkManager = networkManager
    }
    
    @MainActor
    func fetchPosts() async
    {
        do
        {
            self.fetchStatus = .initiated
            self.posts = try await networkManager.fetchPosts(from: "https://jsonplaceholder.typicode.com/posts")
            self.fetchStatus = .success
        }
        
        catch
        {
            self.fetchStatus = .failure
            self.errorMessage = error.localizedDescription
        }
    }
}
