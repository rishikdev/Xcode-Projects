//
//  MyNotesSectionView.swift
//  MyNotes+
//
//  Created by Rishik Dev on 18/07/22.
//

import SwiftUI

struct MyNotesSectionView: View
{
    @StateObject var myNotesViewModel: MyNotesViewModel
    @StateObject var quickSettings: QuickSettingsClass
    
    @State private var searchQuery: String = ""
    
    var body: some View
    {
        Section(header: Text("Pinned Notes"))
        {
            // This for loop displays the pinned notes
            ForEach(searchResults)
            {
                noteEntity in
                
                if(noteEntity.isPinned)
                {
                    NotesCellListView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                        .transition(.scale)
                        .swipeActions(edge: .leading, allowsFullSwipe: true)
                        {
                            Button(action: {
                                withAnimation
                                {
                                    noteEntity.isPinned.toggle()
                                    myNotesViewModel.updateNote()
                                }
                            })
                            {
                                Image(systemName: noteEntity.isPinned ? "pin.slash" : "pin")
                            }
                            .tint(.blue)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true)
                        {
                            Button(role: .destructive, action: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                                {
                                    withAnimation
                                    {
                                        myNotesViewModel.deleteNoteByID(noteID: noteEntity.noteID!)
                                    }
                                }
                            })
                            {
                                Image(systemName: "trash")
                            }
                        }
                        .contextMenu
                        {
                            withAnimation
                            {
                                ContextMenuItems(myNotesVViewModel: myNotesViewModel, myNotesEntity: noteEntity, isGridView: false)
                                    .transition(.scale)
                            }
                        }
                }
            }
        }
        
        Section(header: Text("Unpinned Notes"))
        {
            ForEach(searchResults)
            {
                noteEntity in
                
                if(!noteEntity.isPinned)
                {
                    NotesCellListView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                        .transition(.scale)
                        .swipeActions(edge: .leading, allowsFullSwipe: true)
                        {
                            Button(action: {
                                withAnimation
                                {
                                    noteEntity.isPinned.toggle()
                                    myNotesViewModel.updateNote()
                                }
                            })
                            {
                                Image(systemName: noteEntity.isPinned ? "pin.slash" : "pin")
                            }
                            .tint(.blue)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true)
                        {
                            Button(role: .destructive, action: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                                {
                                    withAnimation
                                    {
                                        myNotesViewModel.deleteNoteByID(noteID: noteEntity.noteID!)
                                    }
                                }
                            })
                            {
                                Image(systemName: "trash")
                            }
                        }
                        .contextMenu
                        {
                            withAnimation
                            {
                                ContextMenuItems(myNotesVViewModel: myNotesViewModel, myNotesEntity: noteEntity, isGridView: false)
                                    .transition(.scale)
                            }
                        }
                }
            }
        }
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

//struct MyNotesSectionView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        MyNotesSectionView()
//    }
//}
