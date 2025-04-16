//
//  FileHandler.swift
//  AudioPlayer
//
//  Created by Rishik Dev on 12/07/24.
//

import Foundation
import AVFAudio

class FileHandler: FileHandlerProtocol {
    private init() { }
    static let shared = FileHandler()
    
    func openFolder(path: URL) -> Result<[URL], any Error> {
        var directoryError: (any Error)?
        
        if path.startAccessingSecurityScopedResource() {
            do {
                return try Result.success(FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil))
            } catch {
                directoryError = error
            }
            path.stopAccessingSecurityScopedResource()
        } else {
            path.stopAccessingSecurityScopedResource()
            if let directoryError {
                return Result.failure(directoryError)
            } else {
                return Result.failure(FileError.SecurityError)
            }
        }
        
        path.stopAccessingSecurityScopedResource()
        return Result.failure(FileError.AccessDeniedError)
    }
    
    func loadFiles(paths: [URL]) -> Result<[AudioModel], any Error> {
        var audioFiles: [AudioModel] = []
        
        do {
            for path in paths {
                let avAudioFile = try AVAudioFile(forReading: path)
                
                let name = path.lastPathComponent
                let duration = Double(avAudioFile.length)/avAudioFile.fileFormat.sampleRate
                let playedDuration = 0.0
                let audioFile = AudioModel(name: name, duration: duration, path: path, playedDuration: playedDuration)
                
                audioFiles.append(audioFile)
            }
        } catch {
            print("Error \(error)")
            return .failure(error)
        }
        return .success(audioFiles)
    }
    
    func storeAudioFile(audioFile: AudioModel) -> Result<Bool, Error> {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(audioFile)
            
            UserDefaults.standard.setValue(data, forKey: "currentAudioFile")
        } catch {
            return .failure(error)
        }
        
        return .success(true)
    }
}
