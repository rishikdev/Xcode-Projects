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
            NavigationLink(destination: UpdateNoteView(myNotesViewModel: myNotesViewModel, myNotesEntity: noteEntity, noteTitle: noteEntity.noteTitle ?? "", originalNoteTitle: noteEntity.noteTitle ?? "", noteText: noteEntity.noteText ?? "", originalNoteText: noteEntity.noteText ?? "", noteTag: noteEntity.noteTag ?? "⚪️", originalNoteTag: noteEntity.noteTag ?? "⚪️"))
            {
                EmptyView()
            }
            .opacity(0)
            
            if noteEntity.noteText != nil && noteEntity.noteTitle != nil
            {
                if !noteEntity.noteText!.isEmpty || !noteEntity.noteTitle!.isEmpty
                {
                    HStack
                    {
                        VStack(alignment: .leading)
                        {
                            Text(noteEntity.noteTitle?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 ? "No Title" : noteEntity.noteTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No Title")
                                .lineLimit(1)
                                .font(.body.bold())
                                                        
                            HStack
                            {
                                Text(noteEntity.noteDate ?? Date(), style: .date)
                                
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
                        
                        Text(noteEntity.noteTag!)
                    }
                }
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
