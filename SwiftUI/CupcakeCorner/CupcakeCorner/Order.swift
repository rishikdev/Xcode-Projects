//
//  Order.swift
//  CupcakeCorner
//
//  Created by Rishik Dev on 24/07/23.
//

import SwiftUI

class Order: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        didSet {
            if(specialRequestEnabled == false) {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidAddress: Bool {
        !(name.trimmingCharacters(in: .whitespaces).isEmpty || streetAddress.trimmingCharacters(in: .whitespaces).isEmpty || city.trimmingCharacters(in: .whitespaces).isEmpty || zip.trimmingCharacters(in: .whitespaces).isEmpty)
    }
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2
        
        // Complicated cakes cost more
        cost = cost + (Double(type) / 2)
        
        // $1/cake for extra frosting
        if(extraFrosting) {
            cost = cost + Double(quantity)
        }
        
        // $0.50/cake for extra sprinkles
        if(addSprinkles) {
            cost = cost + (Double(quantity)) / 2
        }
        
        return cost
    }
    
    init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type.self, forKey: .type)
        try container.encode(quantity.self, forKey: .quantity)
        try container.encode(extraFrosting.self, forKey: .extraFrosting)
        try container.encode(addSprinkles.self, forKey: .addSprinkles)
        try container.encode(name.self, forKey: .name)
        try container.encode(streetAddress.self, forKey: .streetAddress)
        try container.encode(city.self, forKey: .city)
        try container.encode(zip.self, forKey: .zip)
    }
}
