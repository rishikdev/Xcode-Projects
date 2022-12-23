//
//  MyNotesNonSectionView.swift
//  My Notes
//
//  Created by Rishik Dev on 22/12/22.
//

import SwiftUI

struct MyNotesNonSectionView: View
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
            ForEach(searchResults, id: \.self.noteID)
            {
                noteEntity in
                
                NotesCellListView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                    .modifier(ListViewModifierCollection(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity))
            }
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
            return myNotesViewModel.notesEntities.filter
            {
                quickSettings.currentFilter.contains($0.noteTag!)
            }
        }

        else
        {
            return myNotesViewModel.notesEntities.filter
            {
                ($0.noteTitle!.lowercased().contains(searchQuery.lowercased()) || $0.noteText!.lowercased().contains(searchQuery.lowercased())) && quickSettings.currentFilter.contains($0.noteTag!)
            }
        }
    }
}

struct MyNotesNonSectionView_Previews: PreviewProvider
{
    static var previews: some View
    {
        MyNotesNonSectionView(myNotesViewModel: MyNotesViewModel(), quickSettings: QuickSettingsClass())
    }
}
