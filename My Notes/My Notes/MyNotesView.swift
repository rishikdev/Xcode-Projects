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
    @State private var searchQuery: String = ""
    
    var searchResults: [MyNotesEntity]
    {
        if searchQuery == ""
        {
            return myNotesViewModel.entities
        }
        
        else
        {
            return myNotesViewModel.entities.filter
            {
                $0.noteText!.lowercased().contains(searchQuery.lowercased())
            }
        }
    }
    
    var body: some View
    {
        NavigationView
        {
            List()
            {
                ForEach(searchResults.sorted(by: { (first, second) -> Bool in
                    first.saveDateTime ?? Date() > second.saveDateTime ?? Date()
                }))
                {
                    entity in
                    NotesCell(myNotesViewModel: myNotesViewModel, entity: entity)
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
                }
                
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    NavigationLink(destination: NewNoteView(myNotesViewModel: myNotesViewModel))
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
    @StateObject var myNotesViewModel: MyNotesViewModel
    @State var entity: MyNotesEntity
    
    var body: some View
    {
        ZStack(alignment: .leading)
        {
            NavigationLink(destination: UpdateNoteView(myNotesViewModel: myNotesViewModel, myNotesEntity: entity, textBody: entity.noteText ?? ""))
            {
                EmptyView()
            }
            .opacity(0)
            
            if entity.noteText != nil
            {
                if !entity.noteText!.isEmpty
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
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        MyNotesView()
    }
}
