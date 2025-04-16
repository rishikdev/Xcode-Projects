//
//  PostViewModel.swift
//  CombineMVVM
//
//  Created by Rishik Dev on 28/06/23.
//

import Foundation
import Combine

class PostViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    @Published var posts: [Post] = []
    @Published var isApiCallSuccessful: Bool = true
    
    func getPosts() {
        NetworkManager.shared.getData()
            .sink { [weak self] completion in
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                    self?.isApiCallSuccessful = false
                case .finished:
                    self?.isApiCallSuccessful = true
                }
            } receiveValue: { [weak self] posts in
                self?.posts = posts
            }
            .store(in: &cancellables)
    }
}
