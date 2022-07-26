//
//  WidgetLargeView.swift
//  MyNotesPlusWidgetExtension
//
//  Created by Rishik Dev on 08/07/22.
//

import SwiftUI

struct LargeWidgetView: View
{
    @Environment(\.colorScheme) var colourScheme
    
    var entry: LargeWidgetIntentSimpleEntry
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View
    {
        VStack
        {
            if(entry.sharedData.count > 0)
            {
                if(entry.configuration.showListOfNotes! as! Bool)
                {
                    NoteListView(entry: entry)
                }
                
                else
                {
                    if(entry.sharedData.firstIndex(where: { $0.noteID.uuidString == entry.configuration.Note?.identifier ?? UUID().uuidString }) != nil)
                    {
                        NoteSingleCardView(entry: entry)
                    }
                    
                    else
                    {
                        DefaultNodeSingleCardView(entry: entry)
                    }
                }
            }
            
            else
            {
                HStack
                {
                    Text("My Notes +")
                        .fontWeight(.black)
                        .padding(10)
                    
                    Spacer()
                }
                .background(colourScheme == .light ? .white : Color(UIColor.systemGroupedBackground))
                .brightness(-0.15)
                .clipped()
                .shadow(radius: 5)
                
                Spacer()
                
                Text("No Notes")
                    .font(.callout)
                
                Spacer()
            }
        }
        .background(colourScheme == .light ? .white : Color(UIColor.systemGroupedBackground))
    }
}

struct NoteListView: View
{
    @Environment(\.colorScheme) var colourScheme
    
    var entry: LargeWidgetIntentSimpleEntry
    
    var body: some View
    {
        VStack(spacing: 3)
        {
            HStack
            {
                Spacer()
                
                Text("My Notes +")
                    .fontWeight(.black)
                    .padding(.leading, 10)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    .brightness(0.3)
                
                Spacer()
            }
            .background(Color("NoteCardYellowColour"))
            .brightness(-0.15)
            .clipped()
            .shadow(radius: 5)
            
            if(!entry.sharedData[0].noteCardColour.contains("-LOCKED"))
            {
                ForEach(0..<min(entry.sharedData.count, 5), id: \.self )
                {
                    index in
                    
                    VStack(spacing: 4)
                    {
                        HStack
                        {
                            Text(entry.sharedData[index].noteTag)
                            
                            if(entry.sharedData[index].noteTitle.count > 45)
                            {
                                Text("\(String(entry.sharedData[index].noteTitle.suffix(45)))...")
                                    .fontWeight(.semibold)
                            }
                            
                            else
                            {
                                Text(entry.sharedData[index].noteTitle.isEmpty ? "No Title" : entry.sharedData[index].noteTitle)
                                    .fontWeight(.semibold)
                            }
                            
                            Spacer()
                        }
                                            
                        HStack
                        {
                            Text(entry.sharedData[index].noteDate, format: .dateTime.day().month())
                                .font(.caption)
                            
                            Text(entry.sharedData[index].noteText.replacingOccurrences(of: "\n", with: " "))
                                .lineLimit(1)
                            
                            Spacer()
                        }
                        .foregroundColor(.gray)
                        .font(.callout)
                    }
                    .padding(10)
                    
                    Divider()
                        .background(colourScheme == .light ? .gray : .white)
                        
                }
                .padding(.leading, 20)
            }
            
            else
            {
                Spacer()
                
                HStack
                {
                    Image(systemName: "lock.fill")
                    Text("Locked")
                }
            }
            
            Spacer()
        }
        .background(colourScheme == .light ? .white : Color(UIColor.systemGroupedBackground))
        .minimumScaleFactor(0.65)
    }
}

struct NoteSingleCardView: View
{
    @Environment(\.colorScheme) var colourScheme
    var entry: LargeWidgetIntentSimpleEntry
    
    var body: some View
    {
        VStack
        {
            HStack(spacing: 5)
            {
                Text(getNoteTag(noteID: entry.configuration.Note?.identifier ?? UUID().uuidString, entry: entry) ?? entry.sharedData[0].noteTag)
                    .padding(10)

                Text(getNoteTitle(noteID: entry.configuration.Note?.identifier ?? UUID().uuidString, entry: entry) ?? entry.sharedData[0].noteTitle)
                    .fontWeight(.black)
                
                Spacer()
            }
            .background((Color(getNoteCardColour(noteID: entry.configuration.Note?.identifier ?? UUID().uuidString, entry: entry) ?? entry.sharedData[0].noteCardColour)))
            .foregroundColor(.black)
            .brightness(-0.15)
            .clipped()
            .shadow(radius: 5)
            
            Spacer()
            
            if(!entry.sharedData[0].noteCardColour.contains("-LOCKED"))
            {
                Text(getNoteText(noteID:entry.configuration.Note?.identifier ?? UUID().uuidString, entry: entry) ?? entry.sharedData[0].noteText)
                    .padding(5)
                    .font(.callout)
            }
            
            else
            {
                HStack
                {
                    Image(systemName: "lock.fill")
                    Text("Locked")
                }
            }
            
            Spacer()
        }
        .foregroundColor(.black)
        .background((Color(getNoteCardColour(noteID: entry.configuration.Note?.identifier ?? UUID().uuidString, entry: entry) ?? entry.sharedData[0].noteCardColour)))
        .brightness(colourScheme == .light ? 0 : -0.15)
    }
}

struct DefaultNodeSingleCardView: View
{
    @Environment(\.colorScheme) var colourScheme
    var entry: LargeWidgetIntentSimpleEntry
    
    var body: some View
    {
        VStack
        {
            HStack(spacing: 5)
            {
                Text(entry.sharedData[0].noteTag)
                    .padding(10)

                Text(entry.sharedData[0].noteTitle.isEmpty ? "No Title" : entry.sharedData[0].noteTitle)
                    .fontWeight(.black)
                
                Spacer()
            }
            .background((Color(entry.sharedData[0].noteCardColour)))
            .foregroundColor(.black)
            .brightness(-0.15)
            .clipped()
            .shadow(radius: 5)
            
            Spacer()
            
            if(!entry.sharedData[0].noteCardColour.contains("-LOCKED"))
            {
                Text(entry.sharedData[0].noteText)
                    .padding(5)
                    .font(.callout)
            }
            
            else
            {
                HStack
                {
                    Image(systemName: "lock.fill")
                    Text("Locked")
                }
            }
            
            Spacer()
        }
        .foregroundColor(.black)
        .background((Color(entry.sharedData[0].noteCardColour)))
        .brightness(colourScheme == .light ? 0 : -0.15)
    }
}

func getNoteCardColour(noteID: String, entry: LargeWidgetIntentSimpleEntry) -> String?
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

func getNoteTag(noteID: String, entry: LargeWidgetIntentSimpleEntry) -> String?
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

func getNoteTitle(noteID: String, entry: LargeWidgetIntentSimpleEntry) -> String?
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

func getNoteText(noteID: String, entry: LargeWidgetIntentSimpleEntry) -> String?
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
