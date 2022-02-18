//
//  MyNotesViewModel.swift
//  My Notes
//
//  Created by Rishik Dev on 18/02/22.
//

import Foundation
import CoreData

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
    
    func addNote(noteText: String, dateTime: Date)
    {
        //dateTimeFormatter.dateFormat = "HH:mm E, d MMM y"
        
        let newNote = MyNotesEntity(context: notesContainer.viewContext)
        newNote.noteText = noteText
        //newNote.timeSaved = dateTimeFormatter.string(from: date)
        newNote.saveDateTime = dateTime
                        
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
}

