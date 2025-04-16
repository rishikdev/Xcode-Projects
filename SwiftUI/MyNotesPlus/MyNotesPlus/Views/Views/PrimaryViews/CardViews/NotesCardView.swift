//
//  NotesCardView.swift
//  MyNotesPlus
//
//  Created by Rishik Dev on 13/07/23.
//

import SwiftUI

struct NotesCardView: View {
    @ObservedObject var myNotesViewModel: MyNotesViewModel
    @ObservedObject var quickSettings: QuickSettingsClass
    
    @State private var columns = [GridItem(.adaptive(minimum: UIDevice.current.userInterfaceIdiom == .phone ? 150 : 250))]
    @State private var searchQuery: String = ""
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 40) {
                // MARK: - Pinned notes
                ForEach(searchResults) { noteEntity in
                    if(noteEntity.isPinned) {
                        NotesCellCardView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                            .modifier(CardViewModifierCollection(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity))
                    }
                }
                
                // MARK: - Unpinned notes
                ForEach(searchResults) { noteEntity in
                    if(!noteEntity.isPinned) {
                        NotesCellCardView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                            .modifier(CardViewModifierCollection(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity))
                    }
                }
            }
        }
        .refreshable {
            myNotesViewModel.fetchNotes()
        }
        .searchable(text: $searchQuery)
        .padding(.bottom)
    }
    
    var searchResults: [MyNotesEntity] {
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

struct NotesCardView_Previews: PreviewProvider {
    static var previews: some View {
        NotesCardView(myNotesViewModel: MyNotesViewModel(), quickSettings: QuickSettingsClass())
    }
}
