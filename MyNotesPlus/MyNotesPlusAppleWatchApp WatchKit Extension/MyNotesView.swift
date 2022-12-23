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
            
            ZStack
            {
                if(myNotesViewModel.noteEntities.isEmpty)
                {
                    VStack
                    {
                        Text("No Notes")
                        
                        (Text("Scroll up ") + Text(Image(systemName: "arrow.up.circle")) + Text(" to add one!"))
                            .multilineTextAlignment(.center)
                            .font(.caption2)
                    }
                    .foregroundColor(.gray)
                }
                
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
                                .modifier(ListViewModifierCollection(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity))
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
                                .modifier(ListViewModifierCollection(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity))
                        }
                    }
                }
                .refreshable
                {
                    myNotesViewModel.fetchNotes()
                }
                .navigationTitle("My Notes +")
                .navigationBarTitleDisplayMode(.inline)
                .if(!myNotesViewModel.noteEntities.isEmpty)
                {
                    view in
                    
                    view
                        .searchable(text: $searchQuery)
                }
                // MARK: - toolbar()
                .toolbar()
                {
                    ToolbarItemGroup(placement: .primaryAction)
                    {
                        VStack
                        {
                            addNoteButton
                            
                            HStack
                            {
                                refreshButton
                                filterButton
                            }
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
                Image(systemName: "ellipsis.circle")
                    .overlay(FilterButtonDot(filter: quickSettings))
            }
        }
        .sheet(isPresented: $showFilters)
        {
            FilterMenu(quickSettings: quickSettings)
        }
        .buttonStyle(BorderedButtonStyle(tint: .blue))
    }
    
    // MARK: - refreshButton
    
    var refreshButton: some View
    {
        Button(action: { myNotesViewModel.fetchNotes() })
        {
            Image(systemName: "arrow.clockwise")
        }
        .buttonStyle(BorderedButtonStyle(tint: .yellow))
    }
    
    // MARK: - notesCount
    
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
                        Text(noteEntity.noteTag!)
                        
                        VStack(alignment: .leading)
                        {
                            Text(noteEntity.noteTitle?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 ? "No Title" : noteEntity.noteTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No Title")
                                .lineLimit(1)
                                                        
//                            HStack
//                            {
//                                Text(noteEntity.noteDate ?? Date(), format: .dateTime.day().month())
//
//                                Text(noteEntity.noteText?.replacingOccurrences(of: "\n", with: " ") ?? "No Content")
//                                    .lineLimit(1)
//                            }
//                            .font(.callout)
//                            .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        if(noteEntity.isPinned)
                        {
                            Image(systemName: "pin.circle")
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

// MARK: - Custom ListViewModifierCollection

struct ListViewModifierCollection: ViewModifier
{
    let myNotesViewModel: MyNotesViewModel
    let noteEntity: MyNotesEntity
    
    func body(content: Content) -> some View
    {
        content
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
                    withAnimation
                    {
                        myNotesViewModel.deleteNoteByID(noteID: noteEntity.noteID!)
                    }
                })
                {
                    Image(systemName: "trash")
                }
                .tint(.red)
            }
    }
}

// MARK: - View extension
extension View
{
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View
    {
        if condition
        {
            transform(self)
        }
        else
        {
            self
        }
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
