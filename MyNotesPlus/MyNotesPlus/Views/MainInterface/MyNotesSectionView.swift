//
//  MyNotesSectionView.swift
//  MyNotes+
//
//  Created by Rishik Dev on 18/07/22.
//

import SwiftUI

struct MyNotesSectionView: View
{
    @State var editMode: EditMode = .inactive
    
    @StateObject var myNotesViewModel: MyNotesViewModel
    @StateObject var quickSettings: QuickSettingsClass
    
    @State private var searchQuery: String = ""
    @State private var showFilters: Bool = false
    @State private var showSettings: Bool = false
    
    @State private var currentDevice = UIDevice.current.userInterfaceIdiom
    @State private var activateNewNoteView: Bool = false
    
    var body: some View
    {
        List
        {
            Section(header: Text("Pinned Notes"))
            {
                // MARK: - This for loop displays the pinned notes
                ForEach(searchResults, id: \.self.noteID)
                {
                    noteEntity in
                    
                    if(noteEntity.isPinned)
                    {
                        NotesCellListView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                            .modifier(ListViewModifierCollection(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity))
                    }
                }
            }
            
            Section(header: Text("Unpinned Notes"))
            {
                // MARK: - This for loop displays the unpinned notes
                ForEach(searchResults, id: \.self.noteID)
                {
                    noteEntity in
                    
                    if(!noteEntity.isPinned)
                    {
                        NotesCellListView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                            .modifier(ListViewModifierCollection(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity))
                    }
                }
            }
            .opacity(myNotesViewModel.noteEntities.count == myNotesViewModel.getTotalPinnedNotesCount() ? 0 : 1)
        }
        .refreshable
        {
            myNotesViewModel.fetchNotes()
        }
        .searchable(text: $searchQuery)
    }
    
    // MARK: - searchResults
    
    var searchResults: [MyNotesEntity]
    {
        if searchQuery == ""
        {
            return myNotesViewModel.noteEntities.filter
            {
                quickSettings.currentFilter.contains($0.noteTag!)
            }
        }
        
        else
        {
            return myNotesViewModel.noteEntities.filter
            {
                ($0.noteTitle!.lowercased().contains(searchQuery.lowercased()) || $0.noteText!.lowercased().contains(searchQuery.lowercased())) && quickSettings.currentFilter.contains($0.noteTag!)
            }
        }
    }
}

struct MyNotesSectionView_Previews: PreviewProvider
{
    static var previews: some View
    {
        MyNotesSectionView(myNotesViewModel: MyNotesViewModel(), quickSettings: QuickSettingsClass())
    }
}
