//
//  MyNotesViewModel.swift
//  My Notes
//
//  Created by Rishik Dev on 18/02/22.
//

#if !os(watchOS)
import LocalAuthentication
import WidgetKit
#endif
import Foundation
import CoreData
import SwiftUI

// MARK: - MyNotesViewModel class

@MainActor class MyNotesViewModel: ObservableObject
{
    @Published var noteEntities: [MyNotesEntity] = []
    @Published var sharedDataArray: [SharedData] = []
    
    @AppStorage("firstLaunch") var firstLaunch: Bool = true
//    @AppStorage("isAppLocked") var isAppLocked: Bool = true
    
    @Published var isAuthenticated: Bool = false
    @Published var quickSettings = QuickSettingsClass()
    @Published var didUserDeleteNote: Bool = false
    @Published var isAppLocked: Bool = false
    @Published var sortByKey: String = "noteDate"
    
    let myNotesContainer: NSPersistentCloudKitContainer
    let dateTimeFormatter = DateFormatter()
    
    // MARK: - init()
    
    init()
    {
        myNotesContainer = NSPersistentCloudKitContainer(name: "MyNotesContainer")
        
        // This is creating a new database. check widget's provider
        let storeURL = URL.storeURL(for: "group.SRRSS.MyNotesPlus", databaseName: "MyNotesContainer")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        storeDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.SRRSS.MyNotesPlus")
        myNotesContainer.persistentStoreDescriptions = [storeDescription]
        
        myNotesContainer.loadPersistentStores
        {
            (description, error) in
            if let error = error
            {
                print("ERROR LOADING CORE DATA: \(error)")
            }
        }
        
        myNotesContainer.viewContext.automaticallyMergesChangesFromParent = true
        myNotesContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
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
            noteEntities = try myNotesContainer.viewContext.fetch(request)
            sharedDataArray.removeAll()
            
            for entity in noteEntities
            {
                let noteID = entity.noteID!
                let noteTitle = entity.noteTitle!
                let noteText = entity.noteText!
                let noteTag = entity.noteTag!
                let noteDate = entity.noteDate!
                let noteCardColour = entity.noteCardColour!
                let url = URL(string: "mynotesplus:///\(noteID)")!
                
                let sharedData = SharedData(noteID: noteID, noteTitle: noteTitle, noteText: noteText, noteTag: noteTag, noteCardColour: noteCardColour, noteDate: noteDate, url: url)
                
                sharedDataArray.append(sharedData)
            }
                                    
            #if !os(watchOS)
            WidgetCenter.shared.reloadAllTimelines()
            #endif
        }
        
        catch let error
        {
            print("ERROR FETCHING DATA: \(error)")
        }
    }
    
    // MARK: - saveNote()
    
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
        newNote.noteCardColour = "NoteCardYellowColour"
        newNote.isNoteLocked = quickSettings.isUsingBiometric
        
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
        let entity = noteEntities[index]
        myNotesContainer.viewContext.delete(entity)
        
        saveNote()
    }
    
    // MARK: - deleteNoteByID()
    
    func deleteNoteByID(noteID: UUID) -> Void
    {
        noteEntities.forEach
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
    #if !os(watchOS)
    func authenticate()
    {
        let context = LAContext()
        var error: NSError?
        
        if(context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error))
        {
            let touchIDReason = "Use Touch ID to unlock My Notes Plus"
            
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
                    print("BIOMETRIC AUTH FAILED")
                }
            }
        }
        
        // No biometric system found
        else
        {
            // Do some error handling here
            print("BIOMETRIC NOT FOUND")
            isAuthenticated = true
        }
    }
    #endif
    
    // MARK: - isAnyNotePinned
    
    func isAnyNotePinned() -> Bool
    {
        for entity in noteEntities
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
        
        for entity in noteEntities
        {
            if(entity.isPinned)
            {
                count = count + 1
            }
        }
        
        return count
    }
}

// MARK: - URL extension for sharing data between main app and its extension

public extension URL
{
    static func storeURL(for appGroup: String, databaseName: String) -> URL
    {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else
        {
            fatalError("Shared file container could not be created.")
        }
        
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
