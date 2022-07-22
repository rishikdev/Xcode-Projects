//
//  IntentHandler.swift
//  MyNotesPlusIntents
//
//  Created by Rishik Dev on 13/07/22.
//

import Intents

class IntentHandler: INExtension, ConfigurationIntentHandling, MediumWidgetConfigurationIntentHandling, LargeWidgetConfigurationIntentHandling
{
    // MARK: - Small Widget
    
    @MainActor
    func provideCustomNoteOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<CustomNote>?, Error?) -> Void)
    {
            let notes: [CustomNote] = MyNotesViewModel().sharedDataArray.map
            {
                sharedDatum in
                
                let sharedNote = CustomNote(
                    identifier: sharedDatum.noteID.uuidString,
                    display: sharedDatum.noteTitle.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 ? "No Title" : sharedDatum.noteTitle
                )
                sharedNote.noteCardColour = sharedDatum.noteCardColour
                sharedNote.noteTitle = sharedDatum.noteTitle
                sharedNote.noteText = sharedDatum.noteText
                sharedNote.noteTag = sharedDatum.noteTag
                
                return sharedNote
            }

            // Create a collection with the array of characters.
            let collection = INObjectCollection(items: notes)

            // Call the completion handler, passing the collection.
            completion(collection, nil)
    }
    
    // MARK: - Medium Widget
    
    @MainActor
    func provideCustomNote1OptionsCollection(for intent: MediumWidgetConfigurationIntent, with completion: @escaping (INObjectCollection<CustomNoteMediumWidget>?, Error?) -> Void)
    {
        let notes: [CustomNoteMediumWidget] = MyNotesViewModel().sharedDataArray.map
        {
            note in
            
            let sharedNote = CustomNoteMediumWidget(
                identifier: note.noteID.uuidString,
                display: note.noteTitle.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 ? "No Title" : note.noteTitle
            )
            sharedNote.noteCardColour = note.noteCardColour
            sharedNote.noteTitle = note.noteTitle
            sharedNote.noteText = note.noteText
            sharedNote.noteTag = note.noteTag
            
            return sharedNote
        }

        // Create a collection with the array of characters.
        let collection = INObjectCollection(items: notes)

        // Call the completion handler, passing the collection.
        completion(collection, nil)
    }
    
    @MainActor
    func provideCustomNote2OptionsCollection(for intent: MediumWidgetConfigurationIntent, with completion: @escaping (INObjectCollection<CustomNoteMediumWidget>?, Error?) -> Void)
    {
        let notes: [CustomNoteMediumWidget] = MyNotesViewModel().sharedDataArray.map
        {
            note in
            
            let sharedNote = CustomNoteMediumWidget(
                identifier: note.noteID.uuidString,
                display: note.noteTitle.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 ? "No Title" : note.noteTitle
            )
            sharedNote.noteCardColour = note.noteCardColour
            sharedNote.noteTitle = note.noteTitle
            sharedNote.noteText = note.noteText
            sharedNote.noteTag = note.noteTag
            
            return sharedNote
        }

        // Create a collection with the array of characters.
        let collection = INObjectCollection(items: notes)

        // Call the completion handler, passing the collection.
        completion(collection, nil)
    }
    
    // MARK: - Large Widget
    
    @MainActor
    func provideNoteOptionsCollection(for intent: LargeWidgetConfigurationIntent, with completion: @escaping (INObjectCollection<CustomNoteLargeWidget>?, Error?) -> Void)
    {
            let notes: [CustomNoteLargeWidget] = MyNotesViewModel().sharedDataArray.map
            {
                note in
                
                let sharedNote = CustomNoteLargeWidget(
                    identifier: note.noteID.uuidString,
                    display: note.noteTitle.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 ? "No Title" : note.noteTitle
                )
                sharedNote.noteCardColour = note.noteCardColour
                sharedNote.noteTitle = note.noteTitle
                sharedNote.noteText = note.noteText
                sharedNote.noteTag = note.noteTag
                
                return sharedNote
            }

            // Create a collection with the array of characters.
            let collection = INObjectCollection(items: notes)

            // Call the completion handler, passing the collection.
            completion(collection, nil)
    }
}
