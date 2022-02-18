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
    let dateTimeFormatter = DateFormatter()
    
    var body: some View
    {
        VStack
        {
            HStack
            {
                //Text(notesEntity.timeSaved ?? "")
                Text(myNotesEntity.saveDateTime ?? Date(), style: .date)
                Text(myNotesEntity.saveDateTime ?? Date(), style: .time)
            }
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
            
            myNotesEntity.noteText = textBody
//            notesEntity.timeSaved = dateTimeFormatter.string(from: Date())
            myNotesEntity.saveDateTime = Date()
            myNotesViewModel.updateNote()
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
