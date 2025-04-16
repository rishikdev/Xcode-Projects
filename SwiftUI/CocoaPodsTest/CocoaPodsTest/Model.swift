//
//  Model.swift
//  CombineTutorial
//
//  Created by Rishik Dev on 19/04/23.
//

import ObjectMapper
import SwiftyJSON

class PostModel: Identifiable, Codable, Mappable {
    var userId: Int?
    var id: Int?
    var title: String?
    var body: String?
    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        userId <- map["userId"]
        id <- map["id"]
        title <- map["title"]
        body <- map["body"]
    }
}

struct PostModelSwiftyJSON: Codable {
    var userId: Int?
    var id: Int?
    var title: String?
    var body: String?
    
    init(json: JSON) {
        self.userId = json["userId"].intValue
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.body = json["body"].stringValue
    }
}
