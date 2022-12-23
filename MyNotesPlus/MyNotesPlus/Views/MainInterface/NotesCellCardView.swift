//
//  NotesCellGridView.swift
//  MyNotes+
//
//  Created by Rishik Dev on 18/07/22.
//

import SwiftUI

// MARK: - NotesCellGridView

struct NotesCellCardView: View
{
    @Environment(\.colorScheme) var colourScheme
    
    @StateObject var myNotesViewModel: MyNotesViewModel
    @State var noteEntity: MyNotesEntity
    
    @State private var isNavigationLinkActive = false
    
    @State private var shadowX:CGFloat = 0.1
    @State private var shadowY:CGFloat = 0.1
    @State private var shadowRadius: CGFloat = 0.1
    
    @State private var minWidthiPhone: CGFloat = 150
    @State private var minHeightiPhone: CGFloat = 230
    @State private var minWidthiPad: CGFloat = 200
    @State private var minHeightiPad: CGFloat = 280
    
    // Enable motionManager to enable moving shadows
//    @ObservedObject var motionManager = MotionManager()
    
    @State private var currentDevice = UIDevice.current.userInterfaceIdiom
    
    var body: some View
    {
        ZStack(alignment: .leading)
        {
            // Enable the below RoundedRectangle and disable the .shadow modifier of the RoundedRectangle with .onTapGesture to enable moving shadows
            
//            RoundedRectangle(cornerRadius: 10)
//                .foregroundColor(Color(noteEntity.noteCardColour ?? "NoteCardYellowColour"))
//                .shadow(color: colourScheme == .light ? .gray : Color(noteEntity.noteCardColour!), radius: shadowRadius, x: motionManager.roll * shadowX, y: motionManager.pitch * shadowY)
            
            withAnimation
            {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(noteEntity.noteCardColour ?? "NoteCardYellowColour"))
                    .shadow(color: colourScheme == .light ? .gray : Color(noteEntity.noteCardColour!), radius: shadowRadius, x: shadowX, y: shadowY)
                    .frame(minWidth: currentDevice == .phone ? minWidthiPhone : minWidthiPad, minHeight: currentDevice == .phone ? minHeightiPhone : minHeightiPad)
                    .onTapGesture
                    {
                        withAnimation
                        {
                            shadowX = 0
                            shadowY = 0
                            shadowRadius = 1
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                        {
                            isNavigationLinkActive = true
                            
                            withAnimation
                            {
                                shadowX = 0
                                shadowY = 0
                                shadowRadius = 5
                            }
                        }
                    }
                    .onChange(of: colourScheme)
                    {
                        newColourScheme in
                        
                        shadowX = 0
                        shadowY = 0
                        shadowRadius = 5
                    }
            }
            
            NavigationLink(destination: UpdateNoteView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity, noteTitle: noteEntity.noteTitle ?? "", originalNoteTitle: noteEntity.noteTitle ?? "", noteText: noteEntity.noteText ?? "", originalNoteText: noteEntity.noteText ?? "", noteTag: noteEntity.noteTag ?? "⚪️", originalNoteTag: noteEntity.noteTag ?? "⚪️"), isActive: $isNavigationLinkActive)
            {
                EmptyView()
            }
            .opacity(0)
            
            if(noteEntity.noteText != nil && noteEntity.noteTitle != nil)
            {
//                if(!noteEntity.noteText!.isEmpty || !noteEntity.noteTitle!.isEmpty)
//                {
                    VStack
                    {
                        VStack(alignment: .leading)
                        {
                            Text(noteEntity.noteTitle?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 ? "New Note" : noteEntity.noteTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No Title")
                                .font(currentDevice == .phone ? .caption : .body)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                
                            Divider()
                            
                            Text(noteEntity.noteText?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No Content")
                                    .lineLimit(15)
                                    .font(currentDevice == .phone ? .caption2 : .body)
                        }
                        .foregroundColor(.black)
                        
                        Spacer()
                        Divider()
                        
                        HStack
                        {
                            Text(noteEntity.noteTag!)
                            
                            Spacer()
                            
                            if(noteEntity.isPinned)
                            {
                                Image(systemName: "pin.circle")
                                    .font(.body)
                            }
                            
                            Spacer()
                            
                            Text(noteEntity.noteDate ?? Date(), style: .date)
                        }
                        .font(.caption)
                        .foregroundColor(.black)
                    }
                    .padding(10)
//                }
            }
        }
        .onAppear
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75)
            {
                withAnimation
                {
                    shadowX = 0
                    shadowY = 0
                    shadowRadius = 5
                }
            }
        }
        .onTapGesture
        {
            withAnimation
            {
                shadowX = 0
                shadowY = 0
                shadowRadius = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
            {
                isNavigationLinkActive = true
                
                withAnimation
                {
                    shadowX = 0
                    shadowY = 0
                    shadowRadius = 5
                }
            }
        }
        .padding(.horizontal)
    }
}

//struct NotesCellGridView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        NotesCellCardView(myNotesViewModel: MyNotesViewModel(), noteEntity: MyNotesEntity())
//    }
//}
