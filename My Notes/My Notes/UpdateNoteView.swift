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
    
    let dateTimeFormatter = DateFormatter()
    
    @State var showTags: Bool = false
    @State var animateButton: Bool = false
    @FocusState private var textBodyIsFocused: Bool
    
    var body: some View
    {
        VStack
        {
            TextEditor(text: $textBody)
                .focused($textBodyIsFocused)
        }
        .padding(.horizontal)
        .toolbar()
        {
            ToolbarItem(placement: .navigationBarTrailing)
            {
                Button(action: updateButtonPressed)
                {
                    Text("Save")
                }
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
                .disabled(isTextAppropriate() ? false : true)
            }
            
            ToolbarItem(placement: .principal)
            {
                VStack
                {
                    Text(myNotesEntity.saveDateTime ?? Date(), style: .date)
                    Text(myNotesEntity.saveDateTime ?? Date(), style: .time)
                }
                .foregroundColor(Color.gray)
                .font(.caption)
            }
            
            ToolbarItem(placement: .bottomBar)
            {
                HStack
                {
                    Button(action: { myNotesViewModel.deleteNoteById(id: myNotesEntity.id!) })
                    {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.accentColor)
                    .disabled(isTextAppropriate() ? false : true)
                    
                    Spacer()
                }
            }
            
            ToolbarItemGroup(placement: .keyboard)
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
            
            ToolbarItemGroup(placement: .keyboard)
            {
                Button(action: { textBodyIsFocused = false })
                {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
            }
        }
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
            textBodyIsFocused = false
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
//            UpdateNoteView(myNotesViewModel: MyNotesViewModel(), myNotesEntity: MyNotesEntity(), textBody: "")
//        }
//        .padding()
//    }
//}
