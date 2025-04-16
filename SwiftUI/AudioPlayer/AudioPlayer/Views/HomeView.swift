//
//  ContentView.swift
//  AudioPlayer
//
//  Created by Rishik Dev on 10/07/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var fileAndPlayerHandlerVM: FileAndPlayerHandlerViewModel = FileAndPlayerHandlerViewModel(fileHandler: FileHandler.shared, playerHandler: PlayerHandler.shared)
    
    @State private var isPresentingFileImporter: Bool = false
    @State private var errorEncountered: Bool = false
    @State private var isLoading: Bool = false
    
    @State private var errorMessage: String = ""
    
    @State private var folderPath: URL? = UserDefaults.standard.url(forKey: "folderPath")
    
    @State private var audioFiles: [AudioModel] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if folderPath != nil && !isLoading {
                        if(fileAndPlayerHandlerVM.audioFiles.isEmpty) {
                            NoAudioView(folderName: folderPath?.lastPathComponent ?? "")
                        }
                        AudioListView(playerHandlerVM: fileAndPlayerHandlerVM)
                        PlayerControlsView(fileAndPlayerHandlerVM: fileAndPlayerHandlerVM)
                    } else if folderPath == nil && !isLoading {
                        SelectFolderView()
                    }
                }
                
                if(isLoading) {
                    LoadingView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        self.isLoading = true
                        self.isPresentingFileImporter.toggle()
                    }, label: {
                        Image(systemName: "folder.fill")
                    })
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        self.fileAndPlayerHandlerVM.startPlayingAudioFile( fileAndPlayerHandlerVM.audioFiles[0])
                    }, label: {
                        Image("playlist.play")
                    })
                    .disabled(fileAndPlayerHandlerVM.audioFiles.isEmpty)
                    .padding(.trailing)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        self.fileAndPlayerHandlerVM.stopPlayingAudioFile()
                    }, label: {
                        Image(systemName: "square.fill")
                    })
                    .disabled(fileAndPlayerHandlerVM.audioFiles.isEmpty)
                }
            }
            .fileImporter(isPresented: $isPresentingFileImporter, allowedContentTypes: [.folder]) { result in
                switch result {
                case .success(let path):
                    fileAndPlayerHandlerVM.openFolder(path: path)
                    withAnimation {
                        self.isLoading = false
                        self.folderPath = path
                        self.audioFiles = fileAndPlayerHandlerVM.audioFiles
                        
                        UserDefaults.standard.set(path, forKey: "folderPath")
                    }
                case .failure(let error):
                    withAnimation {
                        self.isLoading = false
                        self.folderPath = nil
                        self.errorEncountered = true
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
            .alert("Error", isPresented: $errorEncountered, actions: {
                Button { } label: { Text("Dismiss") }
            }, message: {
                Text(self.errorMessage)
            })
            .onChange(of: isPresentingFileImporter) {
                withAnimation {
                    // isPresentingFileImporter is true when file selector sheet is active
                    // isPresentingFileImporter is false when file selector sheet is dismissed
                    self.isLoading = isPresentingFileImporter
                }
            }
            .onChange(of: fileAndPlayerHandlerVM.errorEncountered) {
                if(fileAndPlayerHandlerVM.errorEncountered) {
                    self.errorEncountered = fileAndPlayerHandlerVM.errorEncountered
                    self.errorMessage = fileAndPlayerHandlerVM.errorMessage
                    
                    withAnimation {
                        self.folderPath = nil
                        self.isLoading = false
                        UserDefaults.standard.set(nil, forKey: "folderPath")
                    }
                }
            }
//            .onChange(of: scenePhase) {
//                if scenePhase == .active {
//                    if let folderPath {
//                        self.isLoading = true
//                        self.fileAndPlayerHandlerVM.openFolder(path: folderPath)
//                        self.isLoading = false
//                    }
//                }
//            }
            .navigationTitle("Audio Player")
        }
    }
}

#Preview {
    HomeView()
}
