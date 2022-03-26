//
//  UpdateNoteView.swift
//  My Notes
//
//  Created by Rishik Dev on 18/02/22.
//

import SwiftUI

struct UpdateNoteView: View
{
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var myNotesViewModel: MyNotesViewModel
    
    @State var myNotesEntity: MyNotesEntity
    @State var textBody: String
    @State var selectedTag: String
    @State var showTags: Bool = false
    @State var animateButton: Bool = false
    @State private var showConfirmationDialog = false
    @State var manualUpdateButtonPress: Bool = false
    
    @FocusState private var textBodyIsFocused: Bool
    
    let dateTimeFormatter = DateFormatter()
    
    var body: some View
    {
        VStack
        {
            TextEditor(text: $textBody)
                .focused($textBodyIsFocused)
        }
        .padding(.horizontal)
        .onDisappear
        {
            updateButtonPressed()
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
            
            ToolbarItem(placement: .bottomBar)
            {
                deleteButton
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
    
    var updateButon: some View
    {
        Button(action: {
            manualUpdateButtonPress = true
            updateButtonPressed()
            
        })
        {
            Text("Save")
        }
        .buttonStyle(.plain)
        .foregroundColor(.accentColor)
        .disabled(isTextAppropriate() ? false : true)
    }
    
    var updateTime: some View
    {
        VStack
        {
            Text(myNotesEntity.saveDateTime ?? Date(), style: .date)
            Text(myNotesEntity.saveDateTime ?? Date(), style: .time)
        }
        .foregroundColor(Color.gray)
        .font(.caption)
    }
    
    var deleteButton: some View
    {
        HStack
        {
            Button(action: {
                myNotesViewModel.deleteNoteById(id: myNotesEntity.id!)
            })
            {
                Image(systemName: "trash")
            }
            .buttonStyle(.plain)
            .foregroundColor(.accentColor)
            
            Spacer()
        }
    }
    
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
    
    func updateButtonPressed()
    {
        if isTextAppropriate()
        {
            dateTimeFormatter.dateFormat = "HH:mm E, d MMM y"
            
            myNotesEntity.noteText = textBody
            myNotesEntity.tag = selectedTag
            myNotesEntity.saveDateTime = Date()
            
            myNotesViewModel.updateNote()
            
            textBodyIsFocused = !manualUpdateButtonPress
            
            if(!manualUpdateButtonPress)
            {
                manualUpdateButtonPress = true
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
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5))
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
