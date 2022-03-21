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
    
    @State var textBody: String = ""
    @State var selectedTag: String = "⚪️"
    
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
            ToolbarItemGroup(placement: .navigationBarTrailing)
            {
                Button(action: saveButtonPressed)
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
                    Text(Date(), style: .time)
                }
                .foregroundColor(Color.gray)
                .font(.caption)
            }
            
            ToolbarItemGroup(placement: .keyboard)
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
    
    func saveButtonPressed()
    {
        if isTextAppropriate()
        {
            myNotesViewModel.addNote(noteText: textBody, dateTime: Date(), tag: selectedTag)
            presentationMode.wrappedValue.dismiss()
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
        Group
        {
            NavigationView
            {
                VStack
                {
                    NewNoteView(myNotesViewModel: MyNotesViewModel())
                }
            }
            
            NavigationView
            {
                VStack
                {
                    NewNoteView(myNotesViewModel: MyNotesViewModel())
                }
            }
            .previewDevice("iPhone SE (3rd generation)")
        }
    }
}
