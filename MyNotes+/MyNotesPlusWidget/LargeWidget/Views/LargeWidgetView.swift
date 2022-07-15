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
                    Text("My Notes Plus")
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
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View
    {
        VStack
        {
            HStack
            {
                Text("My Notes Plus")
                    .fontWeight(.black)
                    .padding(10)
                
                Spacer()
            }
            .background(colourScheme == .light ? .white : Color(UIColor.systemGroupedBackground))
//            .foregroundColor(.white)
            .brightness(-0.15)
            .clipped()
            .shadow(radius: 5)
            
            ForEach(0..<(entry.sharedData.count > 5 ? 5 : entry.sharedData.count), id: \.self )
            {
                index in
                
                VStack(spacing: 2.5)
                {
                    HStack
                    {
                        Text(entry.sharedData[index].noteTag)
                            .font(.caption)
                        
                        if(entry.sharedData[index].noteTitle.count > 45)
                        {
                            Text("\(String(entry.sharedData[index].noteTitle.suffix(45)))...")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        
                        else
                        {
                            Text(entry.sharedData[index].noteTitle)
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                    }
                                        
                    HStack
                    {
                        Text(entry.sharedData[index].noteDate, style: .date)
                        Text(entry.sharedData[index].noteText)
                            .lineLimit(1)
                        Spacer()
                    }
                    .font(.caption2)
                }
                .padding(10)
                
                Divider()
                    .background(colourScheme == .light ? .gray : .white)
            }
            
            Spacer()
        }
    }
}

struct NoteSingleCardView: View
{
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
            
            Text(getNoteText(noteID:entry.configuration.Note?.identifier ?? UUID().uuidString, entry: entry) ?? entry.sharedData[0].noteText)
                .padding(5)
                .font(.callout)
            
            Spacer()
        }
        .foregroundColor(.black)
        .background((Color(getNoteCardColour(noteID: entry.configuration.Note?.identifier ?? UUID().uuidString, entry: entry) ?? entry.sharedData[0].noteCardColour)))
    }
}

struct DefaultNodeSingleCardView: View
{
    var entry: LargeWidgetIntentSimpleEntry
    
    var body: some View
    {
        VStack
        {
            HStack(spacing: 5)
            {
                Text(entry.sharedData[0].noteTag)
                    .padding(10)

                Text(entry.sharedData[0].noteTitle)
                    .fontWeight(.black)
                
                Spacer()
            }
            .background((Color(entry.sharedData[0].noteCardColour)))
            .foregroundColor(.black)
            .brightness(-0.15)
            .clipped()
            .shadow(radius: 5)
            
            Spacer()
            
            Text(entry.sharedData[0].noteText)
                .padding(5)
                .font(.callout)
            
            Spacer()
        }
        .foregroundColor(.black)
        .background((Color(entry.sharedData[0].noteCardColour)))
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
            return note.noteTitle
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
