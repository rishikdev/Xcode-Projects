//
//  Errors.swift
//  AudioPlayer
//
//  Created by Rishik Dev on 10/07/24.
//

import Foundation

enum FileError: Error {
    case SecurityError
    case AccessDeniedError
}

enum AudioError: Error {
    case AVSessionError
}
