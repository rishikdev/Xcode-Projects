//
//  MyNotesView.swift
//  MyNotes+
//
//  Created by Rishik Dev on 15/07/22.
//

import SwiftUI

struct MyNotesView: View
{
    @StateObject var myNotesViewModel: MyNotesViewModel
    @StateObject var quickSettings: QuickSettingsClass
    
    @State private var searchQuery: String = ""
    @State private var showFilters: Bool = false
    @State private var showSettings: Bool = false
    
    var body: some View
    {
        NavigationView
        {
            // MARK: - List of notes
            
            List
            {
                // MARK: - Pinned notes
                
                // This for loop displays the unpinned notes
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
                                Button(action: {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1)
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
                                .tint(.red)
                            }
                    }
                }
                
                // MARK: - Unpinned notes
                
                // This for loop displays the unpinned notes
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
                                Button(action: {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1)
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
                                .tint(.red)
                            }
                    }
                }
            }
            .refreshable
            {
                myNotesViewModel.fetchNotes()
            }
            .navigationTitle("My Notes Plus")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchQuery)
            // MARK: - toolbar()
            .toolbar()
            {
                ToolbarItemGroup(placement: .primaryAction)
                {
                    VStack
                    {
                        addNoteButton
                        filterButton
                        Spacer()
                    }
                }
            }
            .onAppear
            {
                myNotesViewModel.fetchNotes()
            }
        }
    }
    
    // MARK: - searchresults
    
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
    
    // MARK: - addNoteButton
    
    var addNoteButton: some View
    {
        NavigationLink(destination: NewNoteView(myNotesViewModel: myNotesViewModel, myNotesEntity: MyNotesEntity(), noteID: UUID()))
        {
            Label("Add Note", systemImage: "square.and.pencil")
        }
        .buttonStyle(BorderedButtonStyle(tint: .green))
        
    }
    
    // MARK: - filterButton
    
    var filterButton: some View
    {
        Button(action: {
            showFilters.toggle()
        })
        {
            HStack
            {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .overlay(FilterButtonDot(filter: quickSettings))
                
                Text("Filter")
            }
        }
        .sheet(isPresented: $showFilters)
        {
            FilterSheet(quickSettings: quickSettings)
        }
        .buttonStyle(BorderedButtonStyle(tint: .blue))
    }
    
    // MARK: - settingsButton_notesCount
    
    var notesCount: some View
    {
        Text(searchResults.count > 0 ? (searchResults.count == 1 ? "1 Note" : "\(searchResults.count) Notes") : "No Notes")
            .font(.caption2)
            .foregroundColor(.gray)
    }
}

// MARK: - NotesCellListView

struct NotesCellListView: View
{
    @StateObject var myNotesViewModel: MyNotesViewModel
    @State var noteEntity: MyNotesEntity
    
    var body: some View
    {
        ZStack
        {
            NavigationLink(destination: NoteView(myNotesViewModel: myNotesViewModel, myNotesEntity: noteEntity, noteTitle: noteEntity.noteTitle ?? "", noteText: noteEntity.noteText ?? "", noteTag: noteEntity.noteTag ?? "⚪️"))
            {
            EmptyView()
            }
            .opacity(0)
            
            if noteEntity.noteText != nil && noteEntity.noteTitle != nil
            {
                if !noteEntity.noteText!.isEmpty || !noteEntity.noteTitle!.isEmpty
                {
                    HStack
                    {
                        VStack(alignment: .leading)
                        {
                            Text(noteEntity.noteTitle?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 ? "No Title" : noteEntity.noteTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No Title")
                                .lineLimit(1)
                                                        
                            VStack
                            {
                                Text(noteEntity.noteText?.replacingOccurrences(of: "\n", with: " ") ?? "No Content")
                                    .lineLimit(1)
                                
                                
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        VStack
                        {
                            HStack
                            {
                                if(noteEntity.isPinned)
                                {
                                    Image(systemName: "pin.circle")
                                }
                            
                                Text(noteEntity.noteTag!)
                            }
                            
                            Text(noteEntity.noteDate ?? Date(), format: .dateTime.day().month())
                                .font(.caption2)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - FilterButtonDot

struct FilterButtonDot: View
{
    @StateObject var filter: QuickSettingsClass
    
    var body: some View
    {
        Text(filter.currentFilter == "🔴🟢🔵🟡⚪️" ? "" : filter.currentFilter)
            .frame(width: 30)
            .font(.headline)
    }
}

struct MyNotesView_Previews: PreviewProvider
{
    static var previews: some View
    {
        NavigationView
        {
            MyNotesView(myNotesViewModel: MyNotesViewModel(), quickSettings: QuickSettingsClass())
        }
    }
}
