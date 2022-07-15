//
//  WidgetMediumView.swift
//  MyNotesPlusWidgetExtension
//
//  Created by Rishik Dev on 08/07/22.
//

import SwiftUI

struct MediumWidgetView: View
{
    var entry: MediumWidgetIntentSimpleEntry
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View
    {
        HStack(spacing: 5)
        {
            if(entry.sharedData.count > 1)
            {
                if(entry.configuration.CustomNote1?.identifier ?? UUID().uuidString == entry.configuration.CustomNote2?.identifier ?? UUID().uuidString)
                {
                    UserSelectedNoteCard(entry: entry, noteID: entry.configuration.CustomNote1?.identifier ?? UUID().uuidString)
                }
                else
                {
                    if(entry.sharedData.firstIndex(where: { $0.noteID.uuidString == entry.configuration.CustomNote1?.identifier ?? UUID().uuidString }) != nil)
                    {
                        UserSelectedNoteCard(entry: entry, noteID: entry.configuration.CustomNote1?.identifier ?? UUID().uuidString)
                    }
                    
                    else
                    {
                        DefaultNoteCard(entry: entry, index: 0)
                    }
                    
                    if(entry.sharedData.firstIndex(where: { $0.noteID.uuidString == entry.configuration.CustomNote2?.identifier ?? UUID().uuidString }) != nil)
                    {
                        UserSelectedNoteCard(entry: entry, noteID: entry.configuration.CustomNote2?.identifier ?? UUID().uuidString)
                    }
                    
                    else
                    {
                        DefaultNoteCard(entry: entry, index: 1)
                    }
                }
            }
            else if(entry.sharedData.count == 1)
            {
                DefaultNoteCard(entry: entry, index: 0)
            }
            
            else
            {
                VStack
                {
                    HStack
                    {
                        Spacer()
                        
                        Text("My Notes Plus")
                            .padding(5)
                        
                        Spacer()
                    }
                    .background(Color("NoteCardYellowColour"))
                    .brightness(-0.15)
                    .clipped()
                    .shadow(radius: 5)
                    
                    Spacer()
                    
                    Text("No Notes")
                        .font(.caption)
                        .padding(5)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .background(Color("NoteCardYellowColour"))
                .foregroundColor(.black)
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [.mint, .purple, .pink]), startPoint: .top, endPoint: .bottom))
    }
}

struct UserSelectedNoteCard: View
{
    var entry: MediumWidgetIntentSimpleEntry
    @State var noteID: String
    
    var body: some View
    {
        VStack
        {
            HStack(spacing: 5)
            {
                Text(getNoteTag(noteID: noteID, entry: entry) ?? entry.sharedData[0].noteTag)
                    .padding(10)
                
                Text(getNoteTitle(noteID: noteID, entry: entry) ?? entry.sharedData[0].noteTitle)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .background(entry.sharedData.count > 0 ? (Color(getNoteCardColour(noteID: noteID, entry: entry) ?? entry.sharedData[0].noteCardColour)) : Color("NoteCardYellowColour"))
            .foregroundColor(.black)
            .brightness(-0.15)
            .clipped()
            .shadow(radius: 5)
            
            Spacer()
            
            Text(getNoteText(noteID: noteID, entry: entry) ?? entry.sharedData[0].noteText)
                .font(.caption)
                .padding(5)
                .foregroundColor(.black)
            
            Spacer()
        }
        .background(Color(getNoteCardColour(noteID: noteID, entry: entry) ?? entry.sharedData[0].noteCardColour))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct DefaultNoteCard: View
{
    var entry: MediumWidgetIntentSimpleEntry
    var index: Int
    
    var body: some View
    {
        VStack
        {
            HStack(spacing: 5)
            {
                Text(entry.sharedData[index].noteTag)
                    .padding(10)
                
                Text(entry.sharedData[index].noteTitle)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .background(Color(entry.sharedData[index].noteCardColour))
            .foregroundColor(.black)
            .brightness(-0.15)
            .clipped()
            .shadow(radius: 5)
            
            Spacer()
            
            Text(entry.sharedData[index].noteText)
                .font(.caption)
                .padding(5)
                .foregroundColor(.black)
            
            Spacer()
        }
        .background(Color(entry.sharedData[index].noteCardColour))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

func getNoteCardColour(noteID: String, entry: MediumWidgetIntentSimpleEntry) -> String?
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

func getNoteTag(noteID: String, entry: MediumWidgetIntentSimpleEntry) -> String?
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

func getNoteTitle(noteID: String, entry: MediumWidgetIntentSimpleEntry) -> String?
{
    for note in entry.sharedData
    {
        if(note.noteID.uuidString == noteID)
        {
            return note.noteTitle
        }
    }
    
    return nil
}

func getNoteText(noteID: String, entry: MediumWidgetIntentSimpleEntry) -> String?
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
