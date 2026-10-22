//
//  ContentView.swift
//  DocGen
//
//  Created by Rishik Dev on 05/10/26.
//

import Combine
import SwiftUI

enum ProcessStatus {
    case idle, initialising, processing, success, failure
}

struct ContentView: View {
    @State private var menuObserver = MenuObserver()
    @State private var dotCount: Int = 0
    @State private var statusText: String = ""
    @State private var functionName: String = ""
    @State private var docGenResponseText: String = ""
    @State private var processStatus: ProcessStatus = .idle
    @State private var isModelLoaded = false
    
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    private var ellipses: String {
        String(repeating: ".", count: dotCount)
    }
    
    var body: some View {
        VStack {
            Text(statusText)
            
            if (processStatus == .processing || processStatus == .initialising) {
                Text(ellipses)
            }
            
            if (processStatus == .success) {
                Button("Copy DocC") {
                    copyToClipboard(docGenResponseText)
                }
                .keyboardShortcut("c")
            }
            
            Button("Quit DocGen") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .task {
            // Load the MLX model asynchronously when the app starts
            if !isModelLoaded {
                self.processStatus = .initialising
                self.statusText = "Loading Qwen2.5 Model (this is slightly slow on first boot)..."
                do {
                    try await AIManager.shared.loadModel()
                    self.isModelLoaded = true
                    self.statusText = "Ready! Copy a Swift function."
                    self.processStatus = .idle
                } catch {
                    self.statusText = "Failed to load model: \(error.localizedDescription)"
                    self.processStatus = .failure
                }
            }
        }
        .onChange(of: menuObserver.isMenuOpen) { _, isMenuOpen in
            if (isMenuOpen && isModelLoaded) {
                handleMenuOpen()
            }
        }
        .onReceive(timer) { _ in
            if (processStatus == .processing || processStatus == .initialising) {
                dotCount = (dotCount + 1) % 4
            }
        }
    }
    
    private func handleMenuOpen() {
        if let copiedText = NSPasteboard.general.string(forType: .string) {
            do {
                let metadata = try FunctionMetadataExtractor.extractMetadata(from: copiedText)
                self.functionName = metadata.name
                self.statusText = "Processing \(functionName)"
                self.processStatus = .processing
                self.docGenResponseText = ""
                                
                Task {
                    do {
                        let stream = try await AIManager.shared.getDocumentation(for: functionName, withMetadata: metadata)
                        
                        for try await chunk in stream {
                            self.docGenResponseText += chunk
                        }
                        
                        self.processStatus = .success
                        self.statusText = "Processing Complete"
                    } catch {
                        self.statusText = error.localizedDescription
                        self.processStatus = .failure
                    }
                }
                
            } catch {
                self.statusText = error.localizedDescription
                self.processStatus = .failure
            }
        } else {
            self.statusText = "Please copy a Swift function."
            self.processStatus = .idle
        }
    }
    
    private func copyToClipboard(_ string: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(string, forType: .string)
    }
}

#Preview {
    ContentView()
}
