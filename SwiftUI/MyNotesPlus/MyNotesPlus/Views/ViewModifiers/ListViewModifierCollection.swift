//
//  ListViewModifierCollection.swift
//  MyNotesPlus
//
//  Created by Rishik Dev on 13/07/23.
//

import SwiftUI

struct ListViewModifierCollection: ViewModifier {
    let myNotesViewModel: MyNotesViewModel
    let noteEntity: MyNotesEntity
    
    func body(content: Content) -> some View {
        content
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            noteEntity.isPinned.toggle()
                            myNotesViewModel.updateNote()
                        }
                    }
                } label: {
                    Label(noteEntity.isPinned ? "Unpin" : "pin", systemImage: noteEntity.isPinned ? "pin.slash" : "pin")
                }
                .tint(.blue)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive, action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation
                        {
                            myNotesViewModel.deleteNoteByID(noteID: noteEntity.noteID!)
                            myNotesViewModel.didUserDeleteNote.toggle()
                        }
                    }
                }) {
                    Image(systemName: "trash")
                }
            }
            .contextMenu {
                withAnimation {
                    ContextMenuItems(myNotesViewModel: myNotesViewModel, myNotesEntity: noteEntity, isCardView: false)
                        .transition(.scale)
                }
            }
    }
}
