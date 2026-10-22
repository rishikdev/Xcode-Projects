//
//  SyntaxError.swift
//  DocGen
//
//  Created by Rishik Dev on 06/10/26.
//

import Foundation

enum SyntaxError: Error, LocalizedError {
    case functionNotFound
    case functionMissingBody
    case functionSyntacticallyInvalid
    
    var errorDescription: String? {
        switch self {
        case .functionNotFound:
            "Could not find a function in the copied text."
        case .functionMissingBody:
            "Could not find the function body."
        case .functionSyntacticallyInvalid:
            "Could not find a syntactically valid function."
        }
    }
}
