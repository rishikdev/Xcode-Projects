//
//  NotesCellListView.swift
//  My Notes
//
//  Created by Rishik Dev on 22/12/22.
//

import SwiftUI

struct NotesCellListView: View
{
    @StateObject var myNotesViewModel: MyNotesViewModel
    @State var noteEntity: MyNotesEntity
    
    var body: some View
    {
        ZStack(alignment: .leading)
        {
            NavigationLink(destination: UpdateNoteView(myNotesViewModel: myNotesViewModel,
                                                      myNotesEntity: noteEntity,
                                                      noteTitle: noteEntity.noteTitle ?? "",
                                                      originalNoteTitle: noteEntity.noteTitle ?? "",
                                                      noteText: noteEntity.noteText ?? "",
                                                      originalNoteText: noteEntity.noteText ?? "",
                                                      noteTag: noteEntity.noteTag ?? "⚪️",
                                                      originalNoteTag: noteEntity.noteTag ?? "⚪️"))
            {
                EmptyView()
            }
            .transition(.opacity)
            .opacity(0)
            
            if(noteEntity.noteText != nil && noteEntity.noteTitle != nil)
            {
//                if(!noteEntity.noteText!.isEmpty || !noteEntity.noteTitle!.isEmpty)
//                {
                    HStack
                    {
                        Text(noteEntity.noteTag!)
                            .padding(.leading, myNotesViewModel.isAnyNotePinned() ? 10 : 0)
                        
                        VStack(alignment: .leading)
                        {
                            Text(noteEntity.noteTitle?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 ? "New Note" : noteEntity.noteTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "New Note")
                                .lineLimit(1)
                                                        
                            HStack
                            {
                                Text(noteEntity.noteDate ?? Date(), format: .dateTime.day().month())
                                
                                Text(noteEntity.noteText?.replacingOccurrences(of: "\n", with: " ") ?? "No Content")
                                    .lineLimit(1)
                            }
                            .font(.callout)
                            .opacity(0.5)
                        }
                        
                        Spacer()
                        
                        if(noteEntity.isPinned)
                        {
                            Image(systemName: "pin.circle")
                        }
                    }
//                }
            }
        }
    }
}

//struct NotesCellListView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        NotesCellListView()
//    }
//}
