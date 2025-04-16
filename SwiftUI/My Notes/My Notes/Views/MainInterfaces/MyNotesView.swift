//
//  ContentView.swift
//  My Notes
//
//  Created by Rishik Dev on 18/02/22.
//

import LocalAuthentication
import SwiftUI

// MARK: - MyNotesView

struct MyNotesView: View
{
    @StateObject var myNotesViewModel: MyNotesViewModel
    @StateObject var quickSettings: QuickSettingsClass
    
    @State private var searchQuery: String = ""
    @State private var showFilters: Bool = false
    @State private var showSettings: Bool = false
    @State private var activateNoteEntryView: Bool = false
    
    // MARK: - MyNotesView body
    
    var body: some View
    {
        NavigationView
        {
            VStack
            {
                Group
                {
                    // MARK: - Section View
                    if(myNotesViewModel.isAnyNotePinned())
                    {
                        MyNotesSectionView(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
                    }
                    
                    // MARK: - Non Section View
                    else
                    {
                        MyNotesNonSectionView(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
                    }
                }
            }
            .navigationTitle("My Notes")
            .toolbar()
            {
                ToolbarItemGroup(placement: .navigationBarTrailing)
                {
                    filterButton
                }
                
                ToolbarItemGroup(placement: .bottomBar)
                {
                    HStack
                    {
                        settingsButton
                        Spacer()
                        notesCount
                        Spacer()
                        newNoteButton
                    }
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
            return myNotesViewModel.notesEntities.filter
            {
                quickSettings.currentFilter.contains($0.noteTag ?? "⚪️")
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
    
    //MARK: - filterButton
    
    var filterButton: some View
    {
        VStack
        {
            Menu
            {
                FilterMenu(quickSettings: quickSettings)
                Divider()
                SortByMenu(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
            }
            label:
            {
                Image(systemName: "ellipsis.circle")
                    .overlay(FilterButtonDot(filter: quickSettings))
                    .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - settingsButton
    
    var settingsButton: some View
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
        .foregroundColor(.accentColor)
    }
    
    // MARK: - notesCount
    
    var notesCount: some View
    {
        Text(searchResults.count > 0 ? (searchResults.count == 1 ? "1 Note" : "\(searchResults.count) Notes") : "No Notes")
            .font(.caption)
            .foregroundColor(.gray)
    }
    
    // MARK: - newNoteButton
    
    var newNoteButton: some View
    {
        NavigationLink(destination: NewNoteView(myNotesViewModel: myNotesViewModel, myNotesEntity: MyNotesEntity(), noteID: UUID()))
        {
            Image(systemName: "square.and.pencil")
        }
        .foregroundColor(.accentColor)
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                    {
                        withAnimation
                        {
                            noteEntity.isPinned.toggle()
                            myNotesViewModel.updateNote()
                        }
                    }
                })
                {
                    Label(noteEntity.isPinned ? "Unpin" : "pin", systemImage: noteEntity.isPinned ? "pin.slash" : "pin")
                }
                .tint(.blue)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true)
            {
                Button(role: .destructive, action: {
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
            }
            .contextMenu
            {
                withAnimation
                {
                    ContextMenuItems(myNotesViewModel: myNotesViewModel, myNotesEntity: noteEntity)
                        .transition(.scale)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        MyNotesView(myNotesViewModel: MyNotesViewModel(), quickSettings: QuickSettingsClass())
    }
}
