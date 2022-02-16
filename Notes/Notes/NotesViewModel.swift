//
//  NotesViewModel.swift
//  Notes
//
//  Created by Rishik Dev on 06/02/22.
//

import Foundation
import CoreData

class NotesViewModel: ObservableObject
{
    @Published var entities: [NotesEntity] = []
    let notesContainer: NSPersistentContainer
    let dateTimeFormatter = DateFormatter()
    
    init()
    {
        notesContainer = NSPersistentContainer(name: "NotesContainer")
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
        let request = NSFetchRequest<NotesEntity>(entityName: "NotesEntity")
        
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
    
    func addNote(body: String, date: Date)
    {
        dateTimeFormatter.dateFormat = "HH:mm E, d MMM y"
        
        let newNote = NotesEntity(context: notesContainer.viewContext)
        newNote.body = body
        newNote.timeSaved = dateTimeFormatter.string(from: date)
        
        print("time: ", dateTimeFormatter.string(from: date))
                
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
