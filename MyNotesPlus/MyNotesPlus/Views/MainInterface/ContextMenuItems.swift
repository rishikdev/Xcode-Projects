//
//  ContextMenuItems.swift
//  MyNotes+
//
//  Created by Rishik Dev on 18/07/22.
//

import SwiftUI

// MARK: - ContextMenuItems

struct ContextMenuItems: View
{
    @StateObject var myNotesVViewModel: MyNotesViewModel
    @State var myNotesEntity: MyNotesEntity
    @State var isCardView: Bool
    
    // MARK: - ContextMenuItems body
    
    var body: some View
    {
        Group
        {
            if(isCardView)
            {
                Menu("Change card")
                {
                    ForEach(["NoteCardYellowColour Yellow", "NoteCardGreenColour Green", "NoteCardPinkColour Pink"], id: \.self)
                    {
                        cardColour in
                        
                        Button(action: {
                            withAnimation
                            {
                                assignCardColour(cardColour: String(cardColour.split(separator: " ")[0]))
                            }
                        })
                        {
                            Text(cardColour.split(separator: " ")[1])
                        }
                    }
                }
            }
            
            Menu("Change tag")
            {
                ForEach(["🔴 Red", "🟢 Green", "🔵 Blue", "🟡 Yellow", "⚪️ White"], id: \.self)
                {
                    buttonText in
                    
                    Button(action: {
                        withAnimation
                        {
                            assignTag(tag: String(buttonText.split(separator: " ")[0]))
                        }
                    })
                    {
                        Text(buttonText)
                    }
                    .transition(.scale)
                }
            }
                        
            Button(action: togglePinNote)
            {
                HStack
                {
                    Text(myNotesEntity.isPinned ? "Unpin" : "Pin")
                    Spacer()
                    Image(systemName: myNotesEntity.isPinned ? "pin.slash" : "pin")
                }
            }
            
            Divider()
            
            Button(role: .destructive, action: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                {
                    withAnimation
                    {
                        myNotesVViewModel.deleteNoteByID(noteID: myNotesEntity.noteID!)
                        myNotesVViewModel.didUserDeleteNote.toggle()
                    }
                }
            })
            {
                VStack
                {
                    Text("Delete")
                    Spacer()
                    Image(systemName: "trash")
                }
            }
        }
    }
    
    // MARK: - assignTag()
    
    func assignTag(tag: String)
    {
        myNotesEntity.noteTag = tag
        myNotesEntity.noteDate = Date()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            withAnimation
            {
                myNotesVViewModel.updateNote()
            }
        }
    }
    
    // MARK: - togglePinNote()
    
    func togglePinNote()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        {
            withAnimation
            {
                myNotesEntity.isPinned.toggle()
                myNotesVViewModel.updateNote()
            }
        }
    }
    
    // MARK: - assignCardColour()
    
    func assignCardColour(cardColour: String)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            withAnimation
            {
                myNotesEntity.noteCardColour = cardColour
                myNotesVViewModel.updateNote()
            }
        }
    }
}


//struct ContextMenuItems_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        ContextMenuItems(myNotesVViewModel: MyNotesViewModel(), myNotesEntity: MyNotesEntity(), isGridView: false)
//    }
//}
