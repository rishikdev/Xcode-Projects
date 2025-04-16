//
//  NetworkManager.swift
//  CombineTutorial
//
//  Created by Rishik Dev on 19/04/23.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    typealias WebServiceResponsePostModel = ([PostModel]?, Error?) -> Void
    
    func getPostsUsingObjectMapper<T: Codable & Mappable>(urlString: String, completion: @escaping ([T]?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        Alamofire.request(url).responseArray { (response: DataResponse<[T]>) in
            if let error = response.error {
                completion(nil, error)
            } else if let posts = response.result.value {
                print("Fetched Data Using Alamofire")
                completion(posts, nil)
            }
        }
    }
    
    func getPostsUsingSwiftyJSON(urlString: String, completion: @escaping WebServiceResponsePostModel) {
        guard let url = URL(string: urlString) else { return }
        
        Alamofire.request(url).responseJSON { response in
            switch(response.result) {
            case .success(let value):
                let json = JSON(value).arrayValue
                var posts = [PostModelSwiftyJSON]()
                print(json)
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
