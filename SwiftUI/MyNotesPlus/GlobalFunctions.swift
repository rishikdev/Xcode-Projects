//
//  GlobalFunctions.swift
//  MyNotesPlus
//
//  Created by Rishik Dev on 13/07/23.
//

import SwiftUI

@MainActor
class GlobalFunctions {
    static let shared = GlobalFunctions()
    private init() {}
    
    func searchResults(myNotesViewModel: MyNotesViewModel, quickSettings: QuickSettingsClass, searchQuery: String) -> [MyNotesEntity] {
        if(searchQuery == "") {
            return myNotesViewModel.noteEntities.filter {
                quickSettings.currentFilter.contains($0.noteTag!)
            }
        } else {
            return myNotesViewModel.noteEntities.filter {
                ($0.noteTitle!.lowercased().contains(searchQuery.lowercased()) || $0.noteText!.lowercased().contains(searchQuery.lowercased())) && quickSettings.currentFilter.contains($0.noteTag!)
            }
        }
    }
}
