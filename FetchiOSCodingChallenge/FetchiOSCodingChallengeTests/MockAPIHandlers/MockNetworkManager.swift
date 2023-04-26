//
//  MockNetworkManager.swift
//  FetchiOSCodingChallengeTests
//
//  Created by Rishik Dev on 24/04/23.
//

import Foundation
@testable import FetchiOSCodingChallenge

class MockNetworkManager: NetworkManagerProtocol {
    var shouldAPICallSucceed: Bool = true
    
    func fetchData<T>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        if(shouldAPICallSucceed) {
            completion(.success(DummyMeal.getDummyMealForTesting() as! T))
        } else {
            completion(.failure(NetworkError.serverError))
        }
    }
}

enum NetworkError: Error {
    case serverError
}
