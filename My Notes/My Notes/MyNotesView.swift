//
//  ContentView.swift
//  My Notes
//
//  Created by Rishik Dev on 18/02/22.
//

import SwiftUI

struct MyNotesView: View
{
    @StateObject var myNotesViewModel = MyNotesViewModel()
    @StateObject var filter = FilterClass()
    
    @State private var searchQuery: String = ""
    @State private var showFilters: Bool = false
    
    var searchResults: [MyNotesEntity]
    {
        if searchQuery == ""
        {
            return myNotesViewModel.entities.filter
            {
                filter.currentFilter.contains($0.tag!)
            }
        }
        
        else
        {
            return myNotesViewModel.entities.filter
            {
                $0.noteText!.lowercased().contains(searchQuery.lowercased()) && filter.currentFilter.contains($0.tag!)
            }
        }
    }
    
    var body: some View
    {
        NavigationView
        {
            List()
            {
                ForEach(searchResults)
                {
                    entity in
                    
                    NotesCell(myNotesViewModel: myNotesViewModel, entity: entity)
                    .contextMenu
                    {
                        ContextMenuItems(myNotesViewModel: myNotesViewModel, entity: entity)
                    }
                }
                .onDelete(perform: myNotesViewModel.deleteNote)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("My Notes")
            .searchable(text: $searchQuery)
            .toolbar()
            {
                ToolbarItem(placement: .navigationBarLeading)
                {
                    EditButton()
                        .buttonStyle(.plain)
                        .foregroundColor(.accentColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button(action: {
                        showFilters.toggle()
                    })
                    {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .overlay(FilterButtonDot(filter: filter))
                    }
                    .sheet(isPresented: $showFilters)
                    {
                        FilterModal(filter: filter)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.accentColor)
                }
                
                ToolbarItemGroup(placement: .bottomBar)
                {
                    Text("")
                    
                    Spacer()
                    
                    Text(searchResults.count > 0 ? (searchResults.count == 1 ? "1 Note" : "\(searchResults.count) Notes") : "No Notes")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    HStack
                    {
                        NavigationLink(destination: NewNoteView(myNotesViewModel: myNotesViewModel))
                        {
                            Image(systemName: "square.and.pencil")
//                                .font(.title3)
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.accentColor)
                    }
                }
            }
            .animation(.interactiveSpring(response: 0.15, dampingFraction: 0.86, blendDuration: 0.25), value: myNotesViewModel.entities)
        }
    }
}

struct NotesCell: View
{
    @StateObject var myNotesViewModel: MyNotesViewModel
    @State var entity: MyNotesEntity
    
    var body: some View
    {        
        ZStack(alignment: .leading)
        {
            NavigationLink(destination: UpdateNoteView(myNotesViewModel: myNotesViewModel, myNotesEntity: entity, textBody: entity.noteText ?? "", selectedTag: entity.tag ?? "⚪️"))
            {
                EmptyView()
            }
            .opacity(0)
            
            if entity.noteText != nil
            {
                if !entity.noteText!.isEmpty
                {
                    HStack
                    {
                        VStack(alignment: .leading)
                        {
                            Text(entity.noteText ?? "No Content")
                                .lineLimit(1)
                                
    //                        Text(entity.timeSaved ?? "No Time")
    //                            .font(.caption2)
                            HStack
                            {
                                Text(entity.saveDateTime ?? Date(), style: .date)
                                    .font(.caption2)
                                Text(entity.saveDateTime ?? Date(), style: .time)
                                    .font(.caption2)
                            }
                        }
                        
                        Spacer()
                        
                        Text(entity.tag!)
                    }
                }
            }
        }
    }
}

struct ContextMenuItems: View
{
    @StateObject var myNotesViewModel: MyNotesViewModel
    @State var entity: MyNotesEntity
    
    var body: some View
    {
        Group
        {
            Text("Tags")
            
            Button(action: {redTag(entity: entity)})
            {
                Text("🔴 Red")
            }
            
            Button(action: {greenTag(entity: entity)})
            {
                Text("🟢 Green")
            }
            
            Button(action: {blueTag(entity: entity)})
            {
                Text("🔵 Blue")
            }
            
            Button(action: {yellowTag(entity: entity)})
            {
                Text("🟡 Yellow")
            }
            
            Button(action: {whiteTag(entity: entity)})
            {
                Text("⚪️ White")
            }
            
            Divider()
            
            Button(role: .destructive, action: {
                myNotesViewModel.deleteNoteById(id: entity.id ?? UUID())
            })
            {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    func redTag(entity: MyNotesEntity)
    {
        entity.tag = "🔴"
        entity.saveDateTime = Date()
        
        myNotesViewModel.updateNote()
    }
    
    func greenTag(entity: MyNotesEntity)
    {
        entity.tag = "🟢"
        entity.saveDateTime = Date()
        
        myNotesViewModel.updateNote()
    }
    
    func blueTag(entity: MyNotesEntity)
    {
        entity.tag = "🔵"
        entity.saveDateTime = Date()
        
        myNotesViewModel.updateNote()
    }
    
    func yellowTag(entity: MyNotesEntity)
    {
        entity.tag = "🟡"
        entity.saveDateTime = Date()
        
        myNotesViewModel.updateNote()
    }
    
    func whiteTag(entity: MyNotesEntity)
    {
        entity.tag = "⚪️"
        entity.saveDateTime = Date()
        
        myNotesViewModel.updateNote()
    }
}

struct FilterButtonDot: View
{
    @StateObject var filter: FilterClass
    
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
        MyNotesView()
    }
}
