//
//  WidgetSmallView.swift
//  MyNotesPlusWidgetExtension
//
//  Created by Rishik Dev on 08/07/22.
//

import SwiftUI

struct SmallWidgetView: View
{
    @Environment(\.colorScheme) var colourScheme
    var entry: SmallWidgetIntentSimpleEntry
    
    var body: some View
    {
        VStack
        {
            HStack(spacing: 5)
            {
                if(entry.sharedData.count > 0)
                {
                    if(entry.sharedData.firstIndex(where: { $0.noteID.uuidString == entry.configuration.CustomNote?.identifier ?? UUID().uuidString }) != nil)
                    {
                        Text(getNoteTag(noteID: entry.configuration.CustomNote?.identifier ?? UUID().uuidString) ?? entry.sharedData[0].noteTag)
                            .padding(10)

                        Text(getNoteTitle(noteID: entry.configuration.CustomNote?.identifier ?? UUID().uuidString) ?? entry.sharedData[0].noteTitle)
                    }
                    
                    else
                    {
                        Text(entry.sharedData[0].noteTag)
                            .padding(10)

                        Text(entry.sharedData[0].noteTitle.isEmpty ? "No Title" : entry.sharedData[0].noteTitle)
                    }
                }
                
                else
                {
                    Spacer()
                    Text("My Notes Plus")
                        .padding(5)
                }
                
                Spacer()
            }
            .background(entry.sharedData.count > 0 ? (Color(getNoteCardColour(noteID: entry.configuration.CustomNote?.identifier ?? UUID().uuidString) ?? entry.sharedData[0].noteCardColour)) : Color("NoteCardYellowColour"))
            .brightness(-0.15)
            .foregroundColor(.black)
            .clipped()
            .shadow(radius: 5)
            
            Spacer()
            
            VStack
            {
                if(entry.sharedData.count > 0)
                {
                    if(!entry.sharedData[0].noteCardColour.contains("-LOCKED"))
                    {
                        if(entry.sharedData.firstIndex(where: { $0.noteID.uuidString == entry.configuration.CustomNote?.identifier ?? UUID().uuidString }) != nil)
                        {
                            Text(getNoteText(noteID:entry.configuration.CustomNote?.identifier ?? UUID().uuidString) ?? entry.sharedData[0].noteText)
                        }
                        
                        else
                        {
                            Text(entry.sharedData[0].noteText)
                        }
                    }
                    
                    else
                    {
                        HStack
                        {
                            Image(systemName: "lock.fill")
                            Text("Locked")
                        }
                    }
                }
                
                else
                {
                    Text("No Notes")
                }
            }
            .font(.caption)
            .padding(5)
            .foregroundColor(.black)
            
            Spacer()
        }
        .background(entry.sharedData.count > 0 ? (Color(getNoteCardColour(noteID: entry.configuration.CustomNote?.identifier ?? UUID().uuidString) ?? entry.sharedData[0].noteCardColour)) : Color("NoteCardYellowColour"))
        .brightness(colourScheme == .light ? 0 : -0.15)
    }
    
    func getNoteCardColour(noteID: String) -> String?
    {
        for note in entry.sharedData
        {
            if(note.noteID.uuidString == noteID)
            {
                return note.noteCardColour
            }
        }
        
        return nil
    }
    
    func getNoteTag(noteID: String) -> String?
    {
        for note in entry.sharedData
        {
            if(note.noteID.uuidString == noteID)
            {
                return note.noteTag
            }
        }
        
        return nil
    }
    
    func getNoteTitle(noteID: String) -> String?
    {
        for note in entry.sharedData
        {
            if(note.noteID.uuidString == noteID)
            {
                return note.noteTitle.isEmpty ? "No Title" : note.noteTitle
            }
        }
        
        return nil
    }
    
    func getNoteText(noteID: String) -> String?
    {
        for note in entry.sharedData
        {
            if(note.noteID.uuidString == noteID)
            {
                return note.noteText
            }
        }
        
        return nil
    }
}
