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
    
    // MARK: - MyNotesView body
    
    var body: some View
    {
        NavigationView
        {
            List
            {
                ForEach(searchResults)
                {
                    noteEntity in
                    
                    NotesCell(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                        .transition(.scale)
                        .contextMenu
                        {
                            ContextMenuItems(myNotesVViewModel: myNotesViewModel, myNotesEntity: noteEntity)
                                .transition(.scale)
                        }
                }
                .onDelete(perform: myNotesViewModel.deleteNote)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("My Notes")
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
    
    // MARK: - settings_Button_notesCount_NewNoteButton
    
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
                .font(.caption)
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

// MARK: - NotesCell

struct NotesCell: View
{
    @StateObject var myNotesViewModel: MyNotesViewModel
    @State var noteEntity: MyNotesEntity
    
    var body: some View
    {        
        ZStack(alignment: .leading)
        {
            NavigationLink(destination: UpdateNoteView(myNotesViewModel: myNotesViewModel, myNotesEntity: noteEntity, noteTitle: noteEntity.noteTitle ?? "", originalNoteTitle: noteEntity.noteTitle ?? "", noteText: noteEntity.noteText ?? "", originalNoteText: noteEntity.noteText ?? "", noteTag: noteEntity.noteTag ?? "??????", originalNoteTag: noteEntity.noteTag ?? "??????"))
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
                                .font(.body.bold())
                                                        
                            HStack
                            {
                                Text(noteEntity.noteDate ?? Date(), style: .date)
//                                Text(noteEntity.noteDate ?? Date(), style: .time)
                                
                                Text(noteEntity.noteText?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No Content")
                                    .lineLimit(1)
                            }
                            .font(.callout)
                            .foregroundColor(Color(UIColor.systemGray))
                        }
                        
                        Spacer()
                                                
                        Text(noteEntity.noteTag!)
                    }
                }
            }
        }
    }
}

// MARK: - ContextMenuItems

struct ContextMenuItems: View
{
    @StateObject var myNotesVViewModel: MyNotesViewModel
    @State var myNotesEntity: MyNotesEntity
    
    // MARK: - ContextMenuItems body
    
    var body: some View
    {
        Group
        {
            Text("Tags")
            ForEach(["???? Red", "???? Green", "???? Blue", "???? Yellow", "?????? White"], id: \.self)
            {
                buttonText in
                
                Button(action: {
                    withAnimation
                    {
                        assignTag(tag: String(buttonText.split(separator: " ")[0]))
                    }
                })
                {
                    Text(buttonText)
                }
                .transition(.scale)
            }
        }
    }
    
    // MARK: - assignTag()
    
    func assignTag(tag: String)
    {
        myNotesEntity.noteTag = tag
        myNotesEntity.noteDate = Date()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7)
        {
            myNotesVViewModel.updateNote()
        }
    }
}

// MARK: - FilterButtonDot

struct FilterButtonDot: View
{
    @StateObject var filter: QuickSettingsClass
    
    var body: some View
    {
        Text(filter.currentFilter == "??????????????????????" ? "" : filter.currentFilter)
            .frame(width: 30)
            .font(.subheadline)
        
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        MyNotesView(myNotesViewModel: MyNotesViewModel(), quickSettings: QuickSettingsClass())
    }
}
