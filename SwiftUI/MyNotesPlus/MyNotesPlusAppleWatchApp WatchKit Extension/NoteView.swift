//
//  ContentView.swift
//  MyNotesPlusAppleWatchApp WatchKit Extension
//
//  Created by Rishik Dev on 15/07/22.
//

import SwiftUI

struct NoteView: View
{
    @ObservedObject var myNotesViewModel: MyNotesViewModel
    
    @State var myNotesEntity: MyNotesEntity
    @State var noteTitle: String
    @State var noteText: String
    @State var noteTag: String
    
    @State var showTags: Bool = false
    @State var animateButton: Bool = false
    @State private var showConfirmationDialog = false
    @State var manualUpdateButtonPress: Bool = false
    
    @FocusState private var textBodyIsFocused: Bool
    
    @State private var isShareSheetPresented: Bool = false
    @State private var isConfirmDeletePresented: Bool = false
    
    let dateTimeFormatter = DateFormatter()
    
    var body: some View
    {
        ScrollView
        {
            VStack
            {
                (Text(noteTag) +
                 Text(" ") + 
                 Text(noteTitle)
                    .fontWeight(.semibold)
                )
                    
                Divider()
                
                Text(noteText)
                    .padding(.bottom)
            }
//        .padding(5)
        }
    }
}

//struct ContentView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        NoteView(myNotesViewModel: MyNotesViewModel(), myNotesEntity: MyNotesViewModel().noteEntities[0], noteTitle: "Test Note", originalNoteTitle: "Test Title", noteText: "Some note text. This is how the watch will display the note.", originalNoteText: "Some note text. This is how the watch will display the note.", noteTag: "🔴", originalNoteTag: "🔴")
//    }
//}
