//
//  ContentView.swift
//  MyNotes+
//
//  Created by Rishik Dev on 11/06/22.
//

#if !os(watchOS)
import LocalAuthentication
#endif
import SwiftUI

// MARK: - MyNotesView

struct MyNotesView: View
{
    @StateObject var myNotesViewModel: MyNotesViewModel
    @StateObject var quickSettings: QuickSettingsClass
    
    @State private var searchQuery: String = ""
    @State private var showFilters: Bool = false
    @State private var showSettings: Bool = false
    @State private var columns = [GridItem(.adaptive(minimum: UIDevice.current.userInterfaceIdiom == .phone ? 150 : 250))]
    
    @State private var cardWidthiPhone: CGFloat = 150
    @State private var cardHeightiPhone: CGFloat = 230
    @State private var cardWidthiPad: CGFloat = 250
    @State private var cardHeightiPad: CGFloat = 350
        
    @State private var currentDevice = UIDevice.current.userInterfaceIdiom
    
    @State private var isConfirmDeletePresented: Bool = false
    
    // MARK: - MyNotesView body
    
    var body: some View
    {
        NavigationView
        {
            switch quickSettings.viewStylePreference
            {
                // MARK: - case .list
                case .list:
                    List
                    {
                        if(myNotesViewModel.isAnyNotePinned())
                        {
                            withAnimation
                            {
                                MyNotesSectionView(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
                            }
                        }
                        
                        else
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
                    .refreshable
                    {
                        myNotesViewModel.fetchNotes()
                    }
                    .listStyle(.insetGrouped)
                    .navigationTitle("My Notes Plus")
                    .searchable(text: $searchQuery)
                    .toolbar()
                    {
                        ToolbarItemGroup(placement: .navigationBarLeading)
                        {
                            editButton
                        }
                        
                        ToolbarItemGroup(placement: .navigationBarTrailing)
                        {
                            filterButton
                        }
                        
                        ToolbarItemGroup(placement: .bottomBar)
                        {
                            settingsButton_notesCount_NewNoteButton
                        }
                    }
                
                // MARK: - case .grid
                case .grid:
                    withAnimation
                    {
                        ScrollView
                        {
                            LazyVGrid(columns: columns, alignment: .center, spacing: 25)
                            {
                                //This for loop displays the pinned notes
                                ForEach(searchResults)
                                {
                                    noteEntity in
                                    
                                    if(noteEntity.isPinned)
                                    {
                                        NotesCellGridView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                                            .frame(width: currentDevice == .phone ? cardWidthiPhone : cardWidthiPad, height: currentDevice == .phone ? cardHeightiPhone : cardHeightiPad)
                                            .transition(.scale)
                                            .contextMenu
                                            {
                                                ContextMenuItems(myNotesVViewModel: myNotesViewModel, myNotesEntity: noteEntity, isGridView: true)
                                                    .transition(.scale)
                                            }
                                    }
                                }
                                
                                //This for loop displays the unpinned notes
                                ForEach(searchResults)
                                {
                                    noteEntity in
                                    
                                    if(!noteEntity.isPinned)
                                    {
                                        NotesCellGridView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                                            .frame(width: currentDevice == .phone ? cardWidthiPhone : cardWidthiPad, height: currentDevice == .phone ? cardHeightiPhone : cardHeightiPad)
                                            .transition(.scale)
                                            .contextMenu
                                            {
                                                ContextMenuItems(myNotesVViewModel: myNotesViewModel, myNotesEntity: noteEntity, isGridView: true)
                                                    .transition(.scale)
                                            }
                                    }
                                }
                            }
                            .refreshable
                            {
                                myNotesViewModel.fetchNotes()
                            }
                            .listStyle(.insetGrouped)
                            .navigationTitle("My Notes Plus")
                            .toolbar()
                            {
                                ToolbarItemGroup(placement: .navigationBarTrailing)
                                {
                                    filterButton
                                }
                                
                                ToolbarItemGroup(placement: .bottomBar)
                                {
                                    settingsButton_notesCount_NewNoteButton
                                }
                            }
                        }
                        .searchable(text: $searchQuery)
                    }
            }
        }
        .navigationViewStyle(.stack)
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
    
    // MARK: - editButton
    
    var editButton: some View
    {
        EditButton()
            .buttonStyle(.plain)
            .foregroundColor(.accentColor)
    }
    
    //MARK: - filterButton
    
    var filterButton: some View
    {
        Button(action: {
            showFilters.toggle()
        })
        {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .overlay(FilterButtonDot(filter: quickSettings))
        }
        .sheet(isPresented: $showFilters)
        {
            FilterSheet(quickSettings: quickSettings)
        }
        .buttonStyle(.plain)
        .foregroundColor(.accentColor)
    }
    
    // MARK: - settingsButton_notesCount_NewNoteButton
    
    var settingsButton_notesCount_NewNoteButton: some View
    {
        Group
        {
            Button(action: {
                showSettings.toggle()
            })
            {
                Image(systemName: "gear")
            }
            .sheet(isPresented: $showSettings)
            {
                SettingsSheet()
            }
            .buttonStyle(.plain)
            .foregroundColor(.accentColor)
            
            Spacer()
            
            Text(searchResults.count > 0 ? (searchResults.count == 1 ? "1 Note" : "\(searchResults.count) Notes") : "No Notes")
                .font(.caption2)
                .foregroundColor(.gray)
            
            Spacer()
            
            HStack
            {
                NavigationLink(destination: NewNoteView(myNotesViewModel: myNotesViewModel, myNotesEntity: MyNotesEntity(), noteID: UUID()))
                {
                    Image(systemName: "square.and.pencil")
                }
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
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
            .font(.subheadline)
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        MyNotesView(myNotesViewModel: MyNotesViewModel(), quickSettings: QuickSettingsClass())
//            .preferredColorScheme(.dark)
    }
}
