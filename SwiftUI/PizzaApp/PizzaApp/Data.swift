//
//  Data.swift
//  PizzaApp
//
//  Created by Rishik Dev on 02/05/23.
//

import Foundation

struct Data: Identifiable {
    var id: UUID
    var titleText: String
    var bodyText: String
    var imageName: String
    var buttonText: String
    var isHidden: Bool
    
    init(id: UUID, titleText: String, bodyText: String, imageName: String, buttonText: String, isHidden: Bool) {
        self.id = id
        self.titleText = titleText
        self.bodyText = bodyText
        self.imageName = imageName
        self.buttonText = buttonText
        self.isHidden = isHidden
    }
    
    static func getDummyData() -> [Data] {
        [Data(id: UUID(),
              titleText: "Let's activate your new equipment",
              bodyText: "When you're ready, we'll guide you through the activation step by step.",
              imageName: "Wifi-Equipment",
              buttonText: "Get Started",
              isHidden: false),
         Data(id: UUID(),
              titleText: "Secure your network",
              bodyText: "Turn on Advanced Security to get peace of mind that your data is secured.",
              imageName: "Secure-Network",
              buttonText: "Configure",
              isHidden: false)]
    }
}
