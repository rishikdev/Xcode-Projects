//
//  NetworkManager.swift
//  CombineTutorial
//
//  Created by Rishik Dev on 14/04/23.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    typealias WebServiceResponse = (Result<[PostModel], Error>) -> Void
    private var cancellables = Set<AnyCancellable>()
    
    func getPosts(urlString: String, completion: @escaping WebServiceResponse) {
        guard let url = URL(string: urlString) else { return }
        
        // 1. Create the publisher
        URLSession.shared.dataTaskPublisher(for: url)
        // 2. Put the publisher to a background thread
            .subscribe(on: DispatchQueue.global(qos: .background)) // This is done by URLSession by default. So it is not needed
        // 3. Receive on main thread
            .receive(on: DispatchQueue.main)
        // 4. tryMap to check that the data is good
            .tryMap(handleOutput)
        // 5. Decode data into PostModel
            .decode(type: [PostModel].self, decoder: JSONDecoder())
        // 6. Sink (put the item into our application)
            .sink { fetchCompletion in
                switch(fetchCompletion) {
                case .finished:
                    print("Fetched Data Using Combine")
                    
                case .failure(let error):
                    print("ERROR: \(error)")
                    completion(.failure(error))
                }
            } receiveValue: { posts in
                completion(.success(posts))
            }
        // 7. Store (cancel subsription is needed)
            .store(in: &cancellables)
    }
    
    private func handleOutput(_ output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        return output.data
    }
}
