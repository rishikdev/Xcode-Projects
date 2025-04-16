//
//  NetworkManager.swift
//  PizzaApp
//
//  Created by Rishik Dev on 25/05/23.
//

import Foundation

class NetworkManager {
    public static var shared = NetworkManager()
    private init() {}
    
    func getPerson(urlString: String, completion: @escaping (Result<Person, Error>) -> Void) {
        guard let url = URL(string: urlString) else { completion(.failure(CustomError.invalidURL)); return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let receivedData = data else { completion(.failure(CustomError.invalidData)); return }
                do {
                    let receivedModel = try JSONDecoder().decode(Person.self, from: receivedData)
                    completion(.success(receivedModel))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

enum CustomError: Error {
    case invalidURL
    case invalidData
}
