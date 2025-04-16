//
//  AudioModel.swift
//  AudioPlayer
//
//  Created by Rishik Dev on 10/07/24.
//

import Foundation

struct AudioModel: Codable, Equatable {
    let name: String
    let duration: Double
    let path: URL
    let playedDuration: Double
}
