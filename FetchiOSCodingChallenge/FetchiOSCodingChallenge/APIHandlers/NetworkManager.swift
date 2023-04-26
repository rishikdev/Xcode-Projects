//
//  NetworkManager.swift
//  FetchiOSCodingChallenge
//
//  Created by Rishik Dev on 24/04/23.
//

import Foundation

protocol NetworkManagerProtocol {
    /// Fetches data from the provided **URL**
    ///
    /// - The parameter `completion` has one argument:
    ///     1. `Result`: If the fetch was successful, it contains an object of the specified type `T`. Otherwise, it contains error message.
    ///
    /// - Parameters:
    ///   - urlString: The **URL** from which data needs to be fetched.
    ///   - completion: An escaping closure with one argument.
    ///
    func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        // Check for valid URL
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let receivedData = data else { return }
                
                do {
                    let receivedModel = try JSONDecoder().decode(T.self, from: receivedData)
                    DispatchQueue.main.async {
                        completion(.success(receivedModel))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
