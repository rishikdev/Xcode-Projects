//
//  ViewModel.swift
//  CombineTutorial
//
//  Created by Rishik Dev on 19/04/23.
//

import Foundation

class PostViewModel: ObservableObject {
    @Published var posts = [PostModel]()
    @Published var isFetchSuccessful = true
    
    var isValidURL: Bool = true
    private let validURL = "https://jsonplaceholder.typicode.com/posts"
    private let invalidURL = "https://jsonplaceholder.typicode.com/post"
    
    func getPostsUsingObjectMapper() {
        NetworkManager.shared.getPostsUsingObjectMapper(urlString: isValidURL ? validURL : invalidURL) { [weak self] (posts: [PostModel]?, error: Error?) in
            if let posts = posts {
                self?.isFetchSuccessful = true
                self?.posts = posts
            }
                
            if let error = error {
                self?.isFetchSuccessful = false
                print("ERROR: \(error)")
            }
        }
    }
    
    func getPostsUsingSwiftyJSON() {
        NetworkManager.shared.getPostsUsingSwiftyJSON(urlString: isValidURL ? validURL : invalidURL) { [weak self] posts, error in
            if let posts = posts {
                self?.isFetchSuccessful = true
                self?.posts = posts
            }
                
            if let error = error {
                self?.isFetchSuccessful = false
                print("ERROR: \(error)")
            }
        }
    }
}
