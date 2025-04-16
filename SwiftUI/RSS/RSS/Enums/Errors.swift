//
//  Errors.swift
//  RSS
//
//  Created by Rishik Dev on 15/01/2025.
//

import Foundation

enum RSSError: String, Error {
    case invalidURL = "Please check the URL and try again."
    case parsingFailed = "Failed to parse RSS."
}
