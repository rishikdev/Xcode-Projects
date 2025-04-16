//
//  Status.swift
//  RSS
//
//  Created by Rishik Dev on 26/02/2025.
//

import Foundation

enum CoreDataTransactionStatus {
    case uninitiated, loading, success, failure
}

enum FetchStatus {
    case uninitiated, loading, success, failure, partialFailure
}

// Remove this enum before shipping the application
enum DeviceType {
    case preview, nonPreview
}
