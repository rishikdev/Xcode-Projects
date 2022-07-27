//
//  UpdateNoteView.swift
//  My Notes
//
//  Created by Rishik Dev on 18/02/22.
//

import SwiftUI

// MARK: - UpdateNoteView

struct UpdateNoteView: View
{
//    @Environment(\.presentationMode) var presentationMode
    
    // This variable keeps track of when the application is dismissed
//    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var myNotesViewModel: MyNotesViewModel
    
    @State var noteEntity: MyNotesEntity
    @State var noteTitle: String
    @State var originalNoteTitle: String
    @State var noteText: String
    @State var originalNoteText: String
    @State var noteTag: String
    @State var originalNoteTag: String
    
//    @State var showTags: Bool = false
//    @State var animateButton: Bool = false
//    @State private var showConfirmationDialog = false
//    @State var manualUpdateButtonPress: Bool = false
//
//    @FocusState private var textBodyIsFocused: Bool
//
//    @State private var isShareSheetPresented: Bool = false
//    @State private var isConfirmDeletePresented: Bool = false
    
    let dateTimeFormatter = DateFormatter()
    
    @State private var currentDevice = UIDevice.current.userInterfaceIdiom
    
    var body: some View
    {
        VStack
        {
            if(myNotesViewModel.noteEntities.contains(noteEntity))
            {
                NoteDetailView(myNotesViewModel: myNotesViewModel,
                               noteEntity: noteEntity,
                               noteTitle: noteTitle,
                               originalNoteTitle: originalNoteTitle,
                               noteText: noteText,
                               originalNoteText: originalNoteText,
                               noteTag: noteTag,
                               originalNoteTag: originalNoteTag)
            }
            
            else
            {
                SelectNoteView(myNotesViewModel: myNotesViewModel)
            }
        }
    }
}

// MARK: - NoteDetailView

struct NoteDetailView: View
{
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    // This variable keeps track of when the application is dismissed
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var myNotesViewModel: MyNotesViewModel
    
    @State var noteEntity: MyNotesEntity
    @State var noteTitle: String
    @State var originalNoteTitle: String
    @State var noteText: String
    @State var originalNoteText: String
    @State var noteTag: String
    @State var originalNoteTag: String
    
    @State var showTags: Bool = false
    @State var animateButton: Bool = false
    @State private var showConfirmationDialog = false
    @State var manualUpdateButtonPress: Bool = false
    
    @FocusState private var textBodyIsFocused: Bool
    
    @State private var isShareSheetPresented: Bool = false
    @State private var isConfirmDeletePresented: Bool = false
    
    let dateTimeFormatter = DateFormatter()
    
    @State private var currentDevice = UIDevice.current.userInterfaceIdiom
    @State var isTestSheetPresented: Bool = false
    
    var body: some View
    {
        VStack
        {
            TextField("Title", text: $noteTitle)
                .font(.largeTitle.bold())
                .focused($textBodyIsFocused)
            
            Divider()
            
            TextEditor(text: $noteText)
                .focused($textBodyIsFocused)
                .padding(.bottom)
        }
        .padding(.horizontal)
        .onChange(of: scenePhase)
        {
            newPhase in
            
            if(newPhase == .inactive)
            {
                if(originalNoteTitle != noteTitle || originalNoteText != noteText || originalNoteTag != noteTag)
                {
                    updateButtonPressed()
                }
            }
        }
        .onDisappear
        {
            if(originalNoteTitle != noteTitle || originalNoteText != noteText || originalNoteTag != noteTag)
            {
                if(!isTextAppropriate())
                {
                    withAnimation
                    {
                        myNotesViewModel.deleteNoteByID(noteID: noteEntity.noteID!)
                    }
                }
                
                else
                {
                    updateButtonPressed()
                }
            }
        }
        .toolbar()
        {
            ToolbarItem(placement: .navigationBarTrailing)
            {
                updateButon
            }
            
            ToolbarItem(placement: .principal)
            {
                updateTime
            }
            
            ToolbarItemGroup(placement: .bottomBar)
            {
                deleteButton
                shareButton
            }
            
            ToolbarItemGroup(placement: .keyboard)
            {
                tagButtonKeyboard
                dismissKeyboardButton
            }
        }
    }
    
    // MARK: - updateButton
    
    var updateButon: some View
    {
        Button(action: {
            manualUpdateButtonPress = true
            updateButtonPressed()
        })
        {
            Text("Done")
        }
        .disabled(isTextAppropriate() ? false : true)
    }
    
    // MARK: - updateTime
    
    var updateTime: some View
    {
        VStack
        {
            Text(noteEntity.noteDate ?? Date(), style: .date)
            Text(noteEntity.noteDate ?? Date(), style: .time)
        }
        .foregroundColor(Color.gray)
        .font(.caption2)
    }
    
    // MARK: - deleteButton
    
    var deleteButton: some View
    {
        Button(role: .destructive, action: {
            self.isConfirmDeletePresented = true
        })
        {
            Image(systemName: "trash")
                .foregroundColor(.red)
        }
        .confirmationDialog("Are you sure you want to delete the note?", isPresented: self.$isConfirmDeletePresented, titleVisibility: .visible)
        {
            Button("Delete", role: .destructive, action: {
                withAnimation
                {
                    myNotesViewModel.deleteNoteByID(noteID: noteEntity.noteID!)
                }
            })
        }
//        message: {
//            Text("You cannot undo this action.")
//        }
    }
    
    // MARK: - shareButton
    
    var shareButton: some View
    {
        Button(action: {
            isShareSheetPresented.toggle()
        })
        {
            Image(systemName: "square.and.arrow.up")
        }
        .sheet(isPresented: $isShareSheetPresented)
        {
            ShareSheetView(activityItems: [noteTitle + "\n" + noteText])
        }
    }
    
    // MARK: - tagButtonKeyboard
    
    var tagButtonKeyboard: some View
    {
        HStack
        {
            tagButton()
                .zIndex(1)
                .padding(.trailing, 20)
            
            HStack(spacing: 20)
            {
                let tags = ["🔴", "🟢", "🔵", "🟡", "⚪️"]
                
                ForEach(tags, id: \.self)
                {
                    tag in
                    
                    if tag != noteTag
                    {
                        Button(action: {
                            withAnimation(.spring())
                            {
                                noteTag = tag

                                showTags.toggle()
                                animateButton.toggle()
                            }
                        })
                        {
                            Text(tag)
                        }
                        .buttonStyle(.plain)
                        .font(.largeTitle)
                    }
                }
            }
            .opacity(showTags ? 1 : 0)
            .zIndex(0)            
        }
    }
    
    // MARK: - dismissKeyboardButton
    
    var dismissKeyboardButton: some View
    {
        Button(action: { textBodyIsFocused = false })
        {
            Image(systemName: "keyboard.chevron.compact.down")
        }
    }
    
    // MARK: - updateButtonPressed()
    
    func updateButtonPressed()
    {
        if isTextAppropriate()
        {
            dateTimeFormatter.dateFormat = "HH:mm E, d MMM y"
            
            noteEntity.noteTitle = noteTitle
            noteEntity.noteText = noteText
            noteEntity.noteTag = noteTag
            noteEntity.noteDate = Date()
            
            withAnimation
            {
                myNotesViewModel.updateNote()
            }
            
            textBodyIsFocused = !manualUpdateButtonPress
            
            if(!manualUpdateButtonPress)
            {
                manualUpdateButtonPress = true
            }
            
//            presentationMode.wrappedValue.dismiss()
        }
    }
    
    // MARK: - isTextAppropriate()
    
    func isTextAppropriate() -> Bool
    {
        if noteText.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 && noteTitle.trimmingCharacters(in: .whitespacesAndNewlines).count == 0
        {
            return false
        }
        
        else
        {
            return true
        }
    }
    
    // MARK: - tagButton()
    
    @ViewBuilder
    func tagButton() -> some View
    {
        Button
        {
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5))
            {
                showTags.toggle()
                animateButton.toggle()
            }
        }
        
        label:
        {
            Text(noteTag)
                .font(.largeTitle)
                .scaleEffect(animateButton ? 1.1 : 1)
        }
        .buttonStyle(.plain)
        .scaleEffect(animateButton ? 1.1 : 1)
    }
}
 
// MARK: - ShareSheetView

private struct ShareSheetView: UIViewControllerRepresentable
{
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
        
    func makeUIViewController(context: Context) -> UIActivityViewController
    {
        let controller = UIActivityViewController( activityItems: activityItems, applicationActivities: applicationActivities)
        
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context)
    {
            // nothing to do here
    }
}

//struct UpdateNoteView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        NavigationView
//        {
//            UpdateNoteView(myNotesViewModel: MyNotesViewModel(), myNotesEntity: MyNotesEntity(), textBody: "", selectedTag: "⚪️")
//        }
//    }
//}
