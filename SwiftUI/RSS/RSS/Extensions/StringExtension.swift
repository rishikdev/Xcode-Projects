//
//  StringExtensions.swift
//  RSS
//
//  Created by Rishik Dev on 10/01/2025.
//

import Foundation
import SwiftUI

extension String {
    func removingHTML() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
    
    func decodeHTMLEntities() -> String {
        guard let data = data(using: .utf8) else { return self }
        guard let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else { return self }
        return attributedString.string
    }
    
    func firstLettersOfEachWord() -> String {
        if (self.isEmpty) {
            return self
        }
        
        return self
            .split { $0 == " " || $0.isNewline }
            .compactMap { $0.first }
            .map { String($0).capitalized }
            .joined()
    }
    
    func rfc822ToTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current

        if let date = dateFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "hh:mm:ss a"
            outputFormatter.timeZone = .current
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")

            return outputFormatter.string(from: date)
        } else {
            return self
        }
    }
    
    func rfc822ToLocalDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current

        if let date = dateFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "EEEE, dd MMM yyyy"
            outputFormatter.timeZone = .current
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")

            return outputFormatter.string(from: date)
        } else {
            return self
        }
    }
    
    func rfc822ToLocalDateTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current

        return dateFormatter.date(from: self)
    }
    
    func rfc822DateToLocalDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current

        return dateFormatter.date(from: self)
    }
    
    func toColour() -> Color {
        if self == "red" {
            return Color.red
        } else if self == "green" {
            return Color.green
        } else if self == "blue" {
            return Color.blue
        } else if self == "yellow" {
            return Color.yellow
        } else if self == "purple" {
            return Color.purple
        } else if self == "brown" {
            return Color.brown
        } else if self == "white" {
            return Color.white
        } else if self == "black" {
            return Color.black
        } else if self == "gray" {
            return Color.gray
        } else {
            return Color.teal
        }
    }
}
