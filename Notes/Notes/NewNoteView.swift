//
//  NewNoteView.swift
//  Notes
//
//  Created by Rishik Dev on 06/02/22.
//

import SwiftUI

struct NewNoteView: View
{
    @Environment(\.presentationMode) var presentationMode
    @StateObject var notesViewModel: NotesViewModel
    
    @State var textBody: String = ""
        
    var body: some View
    {
        VStack
        {
            HStack
            {
                Text(Date(), style: .date)
                Text(Date(), style: .time)
            }
            .padding(.bottom)
            .foregroundColor(Color.gray)
            .font(.callout)
            
            TextEditor(text: $textBody)
        }
        .padding()
        .toolbar()
        {
            ToolbarItem(placement: .navigationBarTrailing)
            {
                Button(action: saveButtonPressed)
                {
                    Text("Save")
                }
                .disabled(isTextAppropriate() ? false : true)
            }
        }
    }
    
    func saveButtonPressed()
    {
        if isTextAppropriate()
        {
            notesViewModel.addNote(body: textBody, date: Date())
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
}

struct NewNoteView_Previews: PreviewProvider
{
    static var previews: some View
    {
        NavigationView
        {
            VStack
            {
                NewNoteView(notesViewModel: NotesViewModel())
            }
        }
    }
}
