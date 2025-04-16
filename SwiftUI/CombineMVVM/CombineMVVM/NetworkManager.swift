//
//  NetworkManager.swift
//  CombineMVVM
//
//  Created by Rishik Dev on 28/06/23.
//

import Foundation
import Combine

enum Endpoint: String {
    case flights
    case details
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() { }
    
    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://jsonplaceholder.typicode.com/posts"
    
    func getData<T: Decodable>() -> Future<[T], Error> {
        return Future<[T], Error> { [weak self] promise in
            guard let self = self,
                  let url = URL(string: self.baseURL) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: [T].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellables)
        }
    }
}


enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
