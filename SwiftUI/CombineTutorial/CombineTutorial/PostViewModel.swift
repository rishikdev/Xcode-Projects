//
//  ViewModel.swift
//  CombineTutorial
//
//  Created by Rishik Dev on 11/04/23.
//

import Foundation

class PostViewModel: ObservableObject {
    @Published var posts = [PostModel]()
    @Published var isFetchSuccessful = true
    
    var isValidURL: Bool = true
    private let validURL = "https://jsonplaceholder.typicode.com/posts"
    private let invalidURL = "https://jsonplaceholder.typicode.com/post"
    
    func getPosts() {
        NetworkManager.shared.getPosts(urlString: isValidURL ? validURL : invalidURL) { [weak self] result in
            switch(result) {
            case .success(let posts):
                self?.isFetchSuccessful = true
                self?.posts = posts
                
            case .failure(let error):
                self?.isFetchSuccessful = false
                print("ERROR: \(error)")
            }
        }
    }
}
