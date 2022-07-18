//
//  NewNoteView.swift
//  My Notes
//
//  Created by Rishik Dev on 18/02/22.
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
    
    @State var showTags: Bool = false
    @State var animateButton: Bool = false
    @State var firstSave: Bool = true
    @State var manualSaveButtonPress: Bool = false
    @State var isDeleted: Bool = false
    
    @FocusState private var textBodyIsFocused: Bool
      
    // MARK: - NewNoteView boody
    
    var body: some View
    {
        VStack
        {
            TextField("Title", text: $noteTitle)
                .font(.largeTitle.bold())
                .focused($textBodyIsFocused)
            
            Divider()
            
            TextEditor(text: $noteText)
                .focused($textBodyIsFocused)
        }
        .onChange(of: scenePhase)
        {
            newPhase in
            
            if(newPhase == .active && isDeleted)
            {
                noteID = UUID()
                
                myNotesEntity = myNotesViewModel.addNote(noteID: noteID, noteTitle: noteTitle, noteText: noteText, noteDate: Date(), noteTag: noteTag)
                
                isDeleted = false
            }
            
            if(newPhase == .inactive)
            {
                if(isTextAppropriate())
                {
                    withAnimation
                    {
                        saveButtonPressed()
                    }
                }
                
                else
                {
                    isDeleted = true
                    myNotesViewModel.deleteNoteByID(noteID: noteID)
                }
            }
        }
        .onAppear
        {
            withAnimation
            {
                if(firstSave)
                {
                    myNotesEntity = myNotesViewModel.addNote(noteID: noteID, noteTitle: noteTitle, noteText: noteText, noteDate: Date(), noteTag: noteTag)
                    
                    firstSave = false
                }
            }
        }
        .onDisappear
        {
            if(isTextAppropriate())
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
                    myNotesViewModel.deleteNoteByID(noteID: noteID)
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
                tagButtonKeyboard
            }
            
            ToolbarItemGroup(placement: .keyboard)
            {
                dismissKeyboardButton
            }
        }
    }
    
    // MARK: - saveButton
    
    var saveButton: some View
    {
        Button(action: {
            manualSaveButtonPress = true
            saveButtonPressed()
            
        })
        {
            Text("Done")
        }
        .buttonStyle(.plain)
        .foregroundColor(.accentColor)
        .disabled(isTextAppropriate() ? false : true)
    }
    
    // MARK: - saveTime
    
    var saveTime: some View
    {
        VStack
        {
            Text(Date(), style: .time)
        }
        .foregroundColor(Color.gray)
        .font(.caption2)
    }
    
    // MARK: - tagButtonKeyboard
    
    var tagButtonKeyboard: some View
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
                    
                    if tag != noteTag
                    {
                        Button(action: {
                            withAnimation(.spring())
                            {
                                noteTag = tag

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
    
    // MARK: - dismissKeyboardButton
    
    var dismissKeyboardButton: some View
    {
        Button(action: { textBodyIsFocused = false })
        {
            Image(systemName: "keyboard.chevron.compact.down")
        }
        .buttonStyle(.plain)
        .foregroundColor(.accentColor)
    }
    
    // MARK: - saveButtonPressed()
    
    func saveButtonPressed()
    {
        if isTextAppropriate()
        {
            myNotesEntity!.noteTitle = noteTitle
            myNotesEntity!.noteText = noteText
            myNotesEntity!.noteTag = noteTag
            myNotesEntity!.noteDate = Date()
            myNotesEntity!.noteCardColour = "NoteCardYellowColour"
            
            myNotesViewModel.updateNote()
            
            textBodyIsFocused = !manualSaveButtonPress
            
            if(!manualSaveButtonPress)
            {
                manualSaveButtonPress = true
            }
            
//            presentationMode.wrappedValue.dismiss()
        }
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
    
    // MARK: - tagButton()
    
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
            Text(noteTag)
                .font(.largeTitle)
                .scaleEffect(animateButton ? 1.1 : 1)
        }
        .buttonStyle(.plain)
        .scaleEffect(animateButton ? 1.1 : 1)
    }
}

//struct NewNoteView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        NavigationView
//        {
//            VStack
//            {
//                NewNoteView(myNotesViewModel: MyNotesViewModel(), myNotesEntity: MyNotesEntity(), noteID: UUID())
//            }
//        }
//    }
//}
