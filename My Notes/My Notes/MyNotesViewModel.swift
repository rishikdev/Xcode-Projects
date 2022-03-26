//
//  MyNotesViewModel.swift
//  My Notes
//
//  Created by Rishik Dev on 18/02/22.
//

import Foundation
import CoreData
import SwiftUI

class MyNotesViewModel: ObservableObject
{
    @Published var notesEntities: [MyNotesEntity] = []
    
    let myNotesContainer: NSPersistentContainer
    
    let dateTimeFormatter = DateFormatter()
    
    init()
    {
        myNotesContainer = NSPersistentContainer(name: "MyNotesContainer")
        myNotesContainer.loadPersistentStores
        {
            (description, error) in
            if let error = error
            {
                print("ERROR LOADING CORE DATA: \(error)")
            }
        }
        
        
        fetchNotes()
    }
    
    func fetchNotes()
    {
        let request = NSFetchRequest<MyNotesEntity>(entityName: "MyNotesEntity")
        let sort = NSSortDescriptor(key: "saveDateTime", ascending: false)
        request.sortDescriptors = [sort]
        
        do
        {
            notesEntities = try myNotesContainer.viewContext.fetch(request)
        }
        
        catch let error
        {
            print("ERROR FETCHING DATA: \(error)")
        }
    }
    
    func saveNote()
    {
        do
        {
            try myNotesContainer.viewContext.save()
            fetchNotes()
        }
        
        catch let error
        {
            print("ERROR SAVING DATA: \(error)")
        }
    }
    
    func addNote(id: UUID, noteText: String, dateTime: Date, tag: String) -> MyNotesEntity
    {
        let newNote = MyNotesEntity(context: myNotesContainer.viewContext)
        
        newNote.id = id;
        newNote.noteText = noteText
        newNote.saveDateTime = dateTime
        newNote.tag = tag
        newNote.folderID = UUID()
        
        saveNote()
        
        return newNote
    }
    
    func updateNote()
    {
        do
        {
            try myNotesContainer.viewContext.save()
            fetchNotes()
        }
        
        catch let error
        {
            print("ERROR UPDATING DATA: \(error)")
        }
    }
    
    func deleteNote(thisIndex: IndexSet)
    {
        guard let index = thisIndex.first else { return }
        let entity = notesEntities[index]
        myNotesContainer.viewContext.delete(entity)
        
        saveNote()
    }
    
    func deleteNoteById(id: UUID) -> Void
    {
        notesEntities.forEach
        {
            entity in
            
            if entity.id == id
            {
                myNotesContainer.viewContext.delete(entity)
            }
        }
                
        saveNote()
    }
}

