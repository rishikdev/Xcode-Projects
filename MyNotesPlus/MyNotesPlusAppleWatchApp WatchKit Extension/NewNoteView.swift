//
//  NewNoteView.swift
//  MyNotes+
//
//  Created by Rishik Dev on 17/07/22.
//

import SwiftUI

// MARK: - NewNoteView

struct NewNoteView: View
{
    @Environment(\.presentationMode) var presentationMode
    
    // This variable keeps track of when the application is dismissed
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var myNotesViewModel: MyNotesViewModel
    
    @State var myNotesEntity: MyNotesEntity?
    @State var noteID: UUID
    @State var noteTitle: String = ""
    @State var noteText: String = ""
    @State var noteTag: String = "⚪️"
        
    @FocusState private var textBodyIsFocused: Bool
    
    var body: some View
    {
        ScrollView
        {
            TextField("Title", text: $noteTitle)
                .font(.body.bold())
                .focused($textBodyIsFocused)
                .onChange(of: noteTitle)
                {
                    print($0)
                }
            
            TextField("Body", text: $noteText)
//                .font(.body.bold())
                .focused($textBodyIsFocused)
                .onChange(of: noteText)
                {
                    print($0)
                }
            
            tagButtonView
                .padding()
            
            saveButton
            cancelButton
        }
    }
    
    // MARK: - saveButton
    
    var saveButton: some View
    {
        Button(action: {
            myNotesViewModel.addNote(noteID: noteID, noteTitle: noteTitle, noteText: noteText, noteDate: Date(), noteTag: noteTag)
            
            presentationMode.wrappedValue.dismiss()
            
        })
        {
            Text("Save")
        }
        .tint(.blue)
        .disabled(isTextAppropriate() ? false : true)
    }
    
    // MARK: - tagButtonView
    
    var tagButtonView: some View
    {
        ScrollView(.horizontal)
        {
            HStack
            {
                HStack
                {
                    let tags = ["⚪️", "🔴", "🟢", "🔵", "🟡"]
                    
                    ForEach(tags, id: \.self)
                    {
                        tag in
                        
                        if tag != noteTag
                        {
                            Button(action: {
                                withAnimation(.spring())
                                {
                                    noteTag = tag
                                }
                            })
                            {
                                Text(tag)
                            }
                            .buttonStyle(.plain)
                            .font(.largeTitle)
                        }
                        
                        else
                        {
                            Button(action: {
                                withAnimation(.spring())
                                {
                                    noteTag = tag
                                }
                            })
                            {
                                Text(tag)
                                    .overlay
                                    {
                                        Image(systemName: "checkmark.circle")
                                    }
                            }
                            .buttonStyle(.plain)
                            .font(.title)
                        }
                    }
                }
                .zIndex(0)
            }
        }
    }
    
    // MARK: - cancelButton
    
    var cancelButton: some View
    {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        })
        {
            Text("Cancel")
        }
        .tint(.red)
    }
    
    // MARK: - isTextAppropriate()
    
    func isTextAppropriate() -> Bool
    {
        if noteText.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 && noteTitle.trimmingCharacters(in: .whitespacesAndNewlines).count == 0
        {
            return false
        }
        
        else
        {
            return true
        }
    }
}

struct NewNoteView_Previews: PreviewProvider
{
    static var previews: some View
    {
        NewNoteView(myNotesViewModel: MyNotesViewModel(), myNotesEntity: MyNotesEntity(), noteID: UUID())
    }
}
