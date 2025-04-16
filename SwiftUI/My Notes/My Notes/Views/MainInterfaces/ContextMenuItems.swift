//
//  ContextMenuItems.swift
//  My Notes
//
//  Created by Rishik Dev on 22/12/22.
//

import SwiftUI

struct ContextMenuItems: View
{
    @StateObject var myNotesViewModel: MyNotesViewModel
    @State var myNotesEntity: MyNotesEntity
    
    // MARK: - ContextMenuItems body
    
    var body: some View
    {
        Group
        {
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
                        myNotesViewModel.deleteNoteByID(noteID: myNotesEntity.noteID!)
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
                myNotesViewModel.updateNote()
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
                myNotesViewModel.updateNote()
            }
        }
    }
}

//struct ContextMenuItems_Previews: PreviewProvider {
//    static var previews: some View {
//        ContextMenuItems()
//    }
//}
