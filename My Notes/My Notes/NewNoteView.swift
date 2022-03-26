//
//  NewNoteView.swift
//  My Notes
//
//  Created by Rishik Dev on 18/02/22.
//

import SwiftUI

struct NewNoteView: View
{
    @Environment(\.presentationMode) var presentationMode
    @StateObject var myNotesViewModel: MyNotesViewModel
    @State var myNotesEntity: MyNotesEntity?
    
    @State var noteId: UUID
    @State var textBody: String = ""
    @State var selectedTag: String = "⚪️"
    
    @State var showTags: Bool = false
    @State var animateButton: Bool = false
    @State var firstSave: Bool = true
    @State var manualSaveButtonPress: Bool = false

    @FocusState private var textBodyIsFocused: Bool
        
    var body: some View
    {
        VStack
        {
            TextEditor(text: $textBody)
                .focused($textBodyIsFocused)
        }
        .onAppear
        {
            withAnimation
            {
                if(firstSave)
                {
                    myNotesEntity = myNotesViewModel.addNote(id: noteId, noteText: textBody, dateTime: Date(), tag: selectedTag)
                    firstSave = false
                }
            }
        }
        .onDisappear
        {
            if(!textBody.isEmpty)
            {
                withAnimation
                {
                    saveButtonPressed()
                }
            }
            
            else
            {
                withAnimation
                {
                    myNotesViewModel.deleteNoteById(id: noteId)
                }
            }
        }
        .padding(.horizontal)
        .toolbar()
        {
            ToolbarItemGroup(placement: .navigationBarTrailing)
            {
                saveButton
            }
            
            ToolbarItem(placement: .principal)
            {
                saveTime
            }
            
            ToolbarItemGroup(placement: .keyboard)
            {
                filterButtonKeyboard
            }
            
            ToolbarItemGroup(placement: .keyboard)
            {
                dismissKeyboardButton
            }
        }
    }
    
    var saveButton: some View
    {
        Button(action: {
            manualSaveButtonPress = true
            saveButtonPressed()
            
        })
        {
            Text("Save")
        }
        .buttonStyle(.plain)
        .foregroundColor(.accentColor)
        .disabled(isTextAppropriate() ? false : true)
    }
    
    var saveTime: some View
    {
        VStack
        {
            Text(Date(), style: .time)
        }
        .foregroundColor(Color.gray)
        .font(.caption)
    }
    
    var filterButtonKeyboard: some View
    {
        HStack
        {
            tagButton()
                .zIndex(1)
                .padding(.trailing, 20)
            
            HStack(spacing: 20)
            {
                let tags = ["🔴", "🟢", "🔵", "🟡", "⚪️"]
                
                ForEach(tags, id: \.self)
                {
                    tag in
                    
                    if tag != selectedTag
                    {
                        Button(action: {
                            withAnimation(.spring())
                            {
                                selectedTag = tag

                                showTags.toggle()
                                animateButton.toggle()
                            }
                        })
                        {
                            Text(tag)
                        }
                        .buttonStyle(.plain)
                        .font(.largeTitle)
                    }
                }
            }
            .opacity(showTags ? 1 : 0)
            .zIndex(0)
        }
    }
    
    var dismissKeyboardButton: some View
    {
        Button(action: { textBodyIsFocused = false })
        {
            Image(systemName: "keyboard.chevron.compact.down")
        }
        .buttonStyle(.plain)
        .foregroundColor(.accentColor)
    }
    
    func saveButtonPressed()
    {
        if isTextAppropriate()
        {
            myNotesEntity!.noteText = textBody
            myNotesEntity!.tag = selectedTag
            myNotesEntity!.saveDateTime = Date()
            
            myNotesViewModel.updateNote()
            
            textBodyIsFocused = !manualSaveButtonPress
            
            if(!manualSaveButtonPress)
            {
                manualSaveButtonPress = true
            }
            
//            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func isTextAppropriate() -> Bool
    {
        if textBody.trimmingCharacters(in: .whitespacesAndNewlines).count == 0
        {
            return false
        }
        
        else
        {
            return true
        }
    }
    
    @ViewBuilder
    func tagButton() -> some View
    {
        Button
        {
            withAnimation(.interactiveSpring(response: 0.15, dampingFraction: 0.86, blendDuration: 0.25))
            {
                showTags.toggle()
                animateButton.toggle()
            }
        }
        
        label:
        {
            Text(selectedTag)
                .font(.largeTitle)
                .scaleEffect(animateButton ? 1.1 : 1)
        }
        .buttonStyle(.plain)
        .scaleEffect(animateButton ? 1.1 : 1)
    }
}

struct NewNoteView_Previews: PreviewProvider
{
    static var previews: some View
    {
        NavigationView
        {
            VStack
            {
                NewNoteView(myNotesViewModel: MyNotesViewModel(), myNotesEntity: MyNotesEntity(), noteId: UUID())
            }
        }
    }
}
