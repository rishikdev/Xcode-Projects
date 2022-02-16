//
//  ContentView.swift
//  Notes
//
//  Created by Rishik Dev on 06/02/22.
//

import SwiftUI

struct NotesView: View
{
    @StateObject var notesViewModel = NotesViewModel()
    @State private var searchQuery: String = ""
    
    var searchResults: [NotesEntity]
    {
        if searchQuery == ""
        {
            return notesViewModel.entities
        }
        
        else
        {
            return notesViewModel.entities.filter
            {
                $0.body!.lowercased().contains(searchQuery.lowercased())
            }
        }
    }
    
    var body: some View
    {
        NavigationView
        {
            List
            {
                ForEach(searchResults)
                {
                    entity in
                    NotesCell(notesViewModel: notesViewModel, entity: entity)
                }
                .onDelete(perform: notesViewModel.deleteNote)
            }
            .listStyle(.automatic)
            .navigationTitle("My Notes")
            .searchable(text: $searchQuery)
            .toolbar()
            {
                ToolbarItem(placement: .navigationBarLeading)
                {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    NavigationLink(destination: NewNoteView(notesViewModel: notesViewModel))
                    {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}

struct NotesCell: View
{
    @StateObject var notesViewModel: NotesViewModel
    @State var entity: NotesEntity
    
    var body: some View
    {
        ZStack(alignment: .leading)
        {
            NavigationLink(destination: UpdateNoteView(notesViewModel: notesViewModel, notesEntity: entity, textBody: entity.body ?? ""))
            {
                EmptyView()
            }
            .opacity(0)
            
            if entity.body != nil
            {
                if !entity.body!.isEmpty
                {
                    VStack(alignment: .leading)
                    {
                        Text(entity.body ?? "No Content")
                            .lineLimit(1)
                            
                        Text(entity.timeSaved ?? "No Time")
                            .font(.caption2)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        NotesView()
    }
}
