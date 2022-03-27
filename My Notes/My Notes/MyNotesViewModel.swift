//
//  MyNotesViewModel.swift
//  My Notes
//
//  Created by Rishik Dev on 18/02/22.
//

import Foundation
import CoreData
import SwiftUI

// MARK: - MyNotesViewModel class

class MyNotesViewModel: ObservableObject
{
    @Published var notesEntities: [MyNotesEntity] = []
    
    let myNotesContainer: NSPersistentContainer
    
    let dateTimeFormatter = DateFormatter()
    
    // MARK: - init()
    
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
    
    // MARK: - fetchNotes()
    
    func fetchNotes()
    {
        let request = NSFetchRequest<MyNotesEntity>(entityName: "MyNotesEntity")
        let sort = NSSortDescriptor(key: "noteDate", ascending: false)
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
    
    // MARK: - saveNote
    
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
    
    // MARK: - addNote()
    
    func addNote(noteID: UUID, noteText: String, noteDate: Date, noteTag: String) -> MyNotesEntity
    {
        let newNote = MyNotesEntity(context: myNotesContainer.viewContext)
        
        newNote.noteID = noteID;
        newNote.noteText = noteText
        newNote.noteDate = noteDate
        newNote.noteTag = noteTag
        
        saveNote()
        
        return newNote
    }
    
    // MARK: - updateNote()
    
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
    
    // MARK: - deleteNote()
    
    func deleteNote(thisIndex: IndexSet)
    {
        guard let index = thisIndex.first else { return }
        let entity = notesEntities[index]
        myNotesContainer.viewContext.delete(entity)
        
        saveNote()
    }
    
    // MARK: - deleteNoteByID()
    
    func deleteNoteByID(noteID: UUID) -> Void
    {
        notesEntities.forEach
        {
            entity in
            
            if entity.noteID == noteID
            {
                print("---- deleted \(noteID) ----")
                myNotesContainer.viewContext.delete(entity)
            }
        }
                
        saveNote()
    }
}

