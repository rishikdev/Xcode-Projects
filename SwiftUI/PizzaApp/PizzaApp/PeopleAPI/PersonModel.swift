//
//  PersonMode.swift
//  PizzaApp
//
//  Created by Rishik Dev on 25/05/23.
//

import Foundation

struct Person: Codable {
    var name, height, mass, hairColour, skinColour, eyeColour, birthYear, gender, homeworld, created, edited, url: String?
    var films, species, vehicles, starships: [String]?
    
    enum CodingKeys: String, CodingKey {
        case hairColour = "hair_color"
        case skinColour = "skin_color"
        case eyeColour = "eye_color"
        case birthYear = "birth_year"
        case name, height, mass, gender, homeworld, created, edited, url, films, species, vehicles, starships
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hairColour = try container.decodeIfPresent(String.self, forKey: .hairColour)
        self.skinColour = try container.decodeIfPresent(String.self, forKey: .skinColour)
        self.eyeColour = try container.decodeIfPresent(String.self, forKey: .eyeColour)
        self.birthYear = try container.decodeIfPresent(String.self, forKey: .birthYear)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.height = try container.decodeIfPresent(String.self, forKey: .height)
        self.mass = try container.decodeIfPresent(String.self, forKey: .mass)
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
        self.homeworld = try container.decodeIfPresent(String.self, forKey: .homeworld)
        self.created = try container.decodeIfPresent(String.self, forKey: .created)
        self.edited = try container.decodeIfPresent(String.self, forKey: .edited)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.films = try container.decode([String].self, forKey: .films)
        self.species = try container.decode([String].self, forKey: .species)
        self.vehicles = try container.decode([String].self, forKey: .vehicles)
        self.starships = try container.decode([String].self, forKey: .starships)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.hairColour, forKey: .hairColour)
        try container.encodeIfPresent(self.skinColour, forKey: .skinColour)
        try container.encodeIfPresent(self.eyeColour, forKey: .eyeColour)
        try container.encodeIfPresent(self.birthYear, forKey: .birthYear)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.height, forKey: .height)
        try container.encodeIfPresent(self.mass, forKey: .mass)
        try container.encodeIfPresent(self.gender, forKey: .gender)
        try container.encodeIfPresent(self.homeworld, forKey: .homeworld)
        try container.encodeIfPresent(self.created, forKey: .created)
        try container.encodeIfPresent(self.edited, forKey: .edited)
        try container.encodeIfPresent(self.url, forKey: .url)
        try container.encode(self.films, forKey: .films)
        try container.encode(self.species, forKey: .species)
        try container.encode(self.vehicles, forKey: .vehicles)
        try container.encode(self.starships, forKey: .starships)
    }
}
