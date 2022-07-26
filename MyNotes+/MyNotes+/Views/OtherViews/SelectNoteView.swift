//
//  SelectNoteView.swift
//  MyNotes+
//
//  Created by Rishik Dev on 19/07/22.
//

import SwiftUI

struct SelectNoteView: View
{
    @StateObject var myNotesViewModel: MyNotesViewModel
    
    var body: some View
    {
        VStack
        {
            Text("Select a note")
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
        .onDisappear
        {
            myNotesViewModel.didUserDeleteNote = false
        }
    }
}

struct SelectNoteView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SelectNoteView(myNotesViewModel: MyNotesViewModel())
    }
}
