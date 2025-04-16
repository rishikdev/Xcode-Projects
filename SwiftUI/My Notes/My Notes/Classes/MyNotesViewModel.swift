//
//  MyNotesViewModel.swift
//  My Notes
//
//  Created by Rishik Dev on 18/02/22.
//

import LocalAuthentication
import Foundation
import CoreData
import SwiftUI

// MARK: - MyNotesViewModel class

@MainActor class MyNotesViewModel: ObservableObject
{
    @AppStorage("firstLaunch") var firstLaunch: Bool = true
    
    @Published var notesEntities: [MyNotesEntity] = []
    @Published var quickSettings = QuickSettingsClass()
    @Published var isAuthenticated: Bool = false
    @Published var sortByKey: String = "noteDate"
    
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
        let sortBy = NSSortDescriptor(key: quickSettings.currentSortByKey, ascending: quickSettings.sortInAscending)
        request.sortDescriptors = [sortBy]
        
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
    
    func addNote(noteID: UUID, noteTitle: String, noteText: String, noteDate: Date, noteTag: String) -> MyNotesEntity
    {
        let newNote = MyNotesEntity(context: myNotesContainer.viewContext)
        
        newNote.noteID = noteID
        newNote.noteTitle = noteTitle
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
                myNotesContainer.viewContext.delete(entity)
            }
        }
                
        saveNote()
    }
    
    // MARK: - authenticate()
    
    func authenticate()
    {
        let context = LAContext()
        var error: NSError?
        
        if(context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error))
        {
            let touchIDReason = "Touch ID is required to unlock My Notes"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: touchIDReason)
            {
                success, authenticationError in
                
                // Biometric authentication successful
                if(success)
                {
                    Task
                    {
                        @MainActor in
                        self.isAuthenticated = true
                    }
                }
                
                // Biometric authentication failed
                else
                {
                    // Do some error handling here
                }
            }
        }
        
        // No biometric system found
        else
        {
            // Do some error handling here
        }
    }
    
    // MARK: - isAnyNotePinned
    
    func isAnyNotePinned() -> Bool
    {
        for entity in notesEntities
        {
            if(entity.isPinned)
            {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - getTotalPinnedNotesCount
    
    func getTotalPinnedNotesCount() -> Int
    {
        var count = 0
        
        for entity in notesEntities
        {
            if(entity.isPinned)
            {
                count = count + 1
            }
        }
        
        return count
    }
}

