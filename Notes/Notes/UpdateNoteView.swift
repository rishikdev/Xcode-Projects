//
//  UpdateNoteView.swift
//  Notes
//
//  Created by Rishik Dev on 06/02/22.
//

import SwiftUI

struct UpdateNoteView: View
{
    @Environment(\.presentationMode) var presentationMode
    @StateObject var notesViewModel: NotesViewModel
    @State var notesEntity: NotesEntity
    @State var textBody: String
    let dateTimeFormatter = DateFormatter()
    
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
            .font(.caption2)
            
            TextEditor(text: $textBody)
        }
        .padding()
        .toolbar()
        {
            ToolbarItem(placement: .navigationBarTrailing)
            {
                Button(action: updateButtonPressed)
                {
                    Text("Update")
                }
            }
        }
    }
    
    func updateButtonPressed()
    {
        if isTextAppropriate()
        {
            dateTimeFormatter.dateFormat = "HH:mm E, d MMM y"
            
            notesEntity.body = textBody
            notesEntity.timeSaved = dateTimeFormatter.string(from: Date())
            notesViewModel.updateNote()
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

struct UpdateNoteView_Previews: PreviewProvider
{
    static var previews: some View
    {
        NavigationView
        {
            UpdateNoteView(notesViewModel: NotesViewModel(), notesEntity: NotesEntity(), textBody: "")
        }
        .padding()
    }
}
