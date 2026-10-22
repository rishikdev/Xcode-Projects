//
//  AIManagerError.swift
//  DocGen
//
//  Created by Rishik Dev on 11/10/26.
//

import Foundation

enum AIManagerError: Error, LocalizedError {
    case modelNotLoaded
    case bundleResourceNotFound
    
    var errorDescription: String? {
        switch self {
        case .modelNotLoaded:
            return "Model not loaded. Please wait for initialisation."
        case .bundleResourceNotFound:
            return "Could not find model resources in the application bundle."
        }
    }
}
