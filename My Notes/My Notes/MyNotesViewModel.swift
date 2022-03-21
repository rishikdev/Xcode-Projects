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
    @Published var entities: [MyNotesEntity] = []
    let notesContainer: NSPersistentContainer
    let dateTimeFormatter = DateFormatter()
    
    init()
    {
        notesContainer = NSPersistentContainer(name: "MyNotesContainer")
        notesContainer.loadPersistentStores
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
            entities = try notesContainer.viewContext.fetch(request)
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
            try notesContainer.viewContext.save()
            fetchNotes()
        }
        
        catch let error
        {
            print("ERROR SAVING DATA: \(error)")
        }
    }
    
    func addNote(noteText: String, dateTime: Date, tag: String)
    {
        let newNote = MyNotesEntity(context: notesContainer.viewContext)
        let id = UUID()
        
        newNote.id = id;
        newNote.noteText = noteText
        newNote.saveDateTime = dateTime
        newNote.tag = tag
                
        saveNote()
    }
    
    func updateNote()
    {
        do
        {
            try notesContainer.viewContext.save()
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
        let entity = entities[index]
        notesContainer.viewContext.delete(entity)
        
        saveNote()
    }
    
    func deleteNoteById(id: UUID) -> Void
    {
        entities.forEach
        {
            entity in
            
            if entity.id == id
            {
                notesContainer.viewContext.delete(entity)
            }
        }
                
        saveNote()
    }
}

