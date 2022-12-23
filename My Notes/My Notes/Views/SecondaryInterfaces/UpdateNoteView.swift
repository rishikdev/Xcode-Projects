//
//  UpdateNoteView.swift
//  My Notes
//
//  Created by Rishik Dev on 18/02/22.
//

import SwiftUI

// MARK: - UpdateNoteView

struct UpdateNoteView: View
{
    @Environment(\.presentationMode) var presentationMode
    
    // This variable keeps track of when the application is dismissed
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var myNotesViewModel: MyNotesViewModel
    
    @State var myNotesEntity: MyNotesEntity
    @State var noteTitle: String
    @State var originalNoteTitle: String
    @State var noteText: String
    @State var originalNoteText: String
    @State var noteTag: String
    @State var originalNoteTag: String
    @State var showTags: Bool = false
    @State var animateButton: Bool = false
    @State private var showConfirmationDialog = false
    @State var manualUpdateButtonPress: Bool = false
    @State private var isConfirmDeletePresented: Bool = false
    
    @FocusState private var textBodyIsFocused: Bool
    
    let dateTimeFormatter = DateFormatter()
    
    // MARK: - UpdateNoteView body
    
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
        .padding(.horizontal)
        .onChange(of: scenePhase)
        {
            newPhase in
            
            if(newPhase == .inactive)
            {
                if(originalNoteTitle != noteTitle || originalNoteText != noteText || originalNoteTag != noteTag)
                {
                    updateButtonPressed()
                }
            }
        }
        .onDisappear
        {
            if(originalNoteTitle != noteTitle || originalNoteText != noteText || originalNoteTag != noteTag)
            {
                if(!isTextAppropriate())
                {
                    withAnimation
                    {
                        myNotesViewModel.deleteNoteByID(noteID: myNotesEntity.noteID!)
                    }
                }
                
                else
                {
                    updateButtonPressed()
                }
            }
        }
        .toolbar()
        {
            ToolbarItem(placement: .navigationBarTrailing)
            {
                updateButon
            }
            
            ToolbarItem(placement: .principal)
            {
                updateTime
            }
            
            ToolbarItemGroup(placement: .bottomBar)
            {
                HStack
                {
                    deleteButton
                    Spacer()
                }
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
    
    // MARK: - updateButton
    
    var updateButon: some View
    {
        Button(action: {
            manualUpdateButtonPress = true
            updateButtonPressed()
            
        })
        {
            Text("Done")
        }
        .buttonStyle(.plain)
        .foregroundColor(.accentColor)
        .disabled(isTextAppropriate() ? false : true)
    }
    
    // MARK: - updateTime
    
    var updateTime: some View
    {
        VStack
        {
            Text(myNotesEntity.noteDate ?? Date(), style: .date)
            Text(myNotesEntity.noteDate ?? Date(), style: .time)
        }
        .foregroundColor(Color.gray)
        .font(.caption)
    }
    
    // MARK: - deleteButton
    
    var deleteButton: some View
    {
        Button(role: .destructive, action: {
            self.isConfirmDeletePresented = true
        })
        {
            Image(systemName: "trash")
                .foregroundColor(.red)
        }
        .confirmationDialog("Are you sure?", isPresented: self.$isConfirmDeletePresented, titleVisibility: .visible)
        {
            Button("Delete", role: .destructive, action: {
                withAnimation
                {
                    myNotesViewModel.deleteNoteByID(noteID: myNotesEntity.noteID!)
                }
            })
        }
        message: {
            Text("You cannot undo this action.")
        }
    }
    
    // MARK: - filterButtonKeyboard
    
    var filterButtonKeyboard: some View
    {
        HStack
        {
            tagButton()
                .zIndex(1)
                .padding(.trailing, 20)
            
            HStack(spacing: 15)
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
    
    // MARK: - updateButtonPressed()
    
    func updateButtonPressed()
    {
        if isTextAppropriate()
        {
            dateTimeFormatter.dateFormat = "HH:mm E, d MMM y"
            
            myNotesEntity.noteTitle = noteTitle
            myNotesEntity.noteText = noteText
            myNotesEntity.noteTag = noteTag
            myNotesEntity.noteDate = Date()
            
            withAnimation
            {
                myNotesViewModel.updateNote()
            }
            
            textBodyIsFocused = !manualUpdateButtonPress
            
            if(!manualUpdateButtonPress)
            {
                manualUpdateButtonPress = true
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
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5))
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

//struct UpdateNoteView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        NavigationView
//        {
//            UpdateNoteView(myNotesViewModel: MyNotesViewModel(), myNotesEntity: MyNotesEntity(), textBody: "", selectedTag: "⚪️")
//        }
//    }
//}
