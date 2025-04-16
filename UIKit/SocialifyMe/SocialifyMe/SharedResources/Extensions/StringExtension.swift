//
//  StringExtension.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 09/03/23.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
}
