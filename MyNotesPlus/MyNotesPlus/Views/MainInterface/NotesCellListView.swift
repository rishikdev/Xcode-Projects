//
//  NotesCellListView.swift
//  MyNotes+
//
//  Created by Rishik Dev on 18/07/22.
//

import SwiftUI

// MARK: - NotesCellListView

struct NotesCellListView: View
{
    @StateObject var myNotesViewModel: MyNotesViewModel
    @State var noteEntity: MyNotesEntity
    
    var body: some View
    {
        ZStack(alignment: .leading)
        {
            NavigationLink(destination: UpdateNoteView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity, noteTitle: noteEntity.noteTitle ?? "", originalNoteTitle: noteEntity.noteTitle ?? "", noteText: noteEntity.noteText ?? "", originalNoteText: noteEntity.noteText ?? "", noteTag: noteEntity.noteTag ?? "⚪️", originalNoteTag: noteEntity.noteTag ?? "⚪️"))
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
                            .foregroundColor(Color(UIColor.systemGray))
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
//        NotesCellListView(myNotesViewModel: MyNotesViewModel(), noteEntity: MyNotesEntity())
//    }
//}
