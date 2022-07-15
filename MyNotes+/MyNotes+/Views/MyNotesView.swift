//
//  ContentView.swift
//  MyNotes+
//
//  Created by Rishik Dev on 11/06/22.
//

import LocalAuthentication
import SwiftUI

// MARK: - MyNotesView

struct MyNotesView: View
{
    @StateObject var myNotesViewModel: MyNotesViewModel
    @StateObject var quickSettings: QuickSettingsClass
    
    @State private var searchQuery: String = ""
    @State private var showFilters: Bool = false
    @State private var showSettings: Bool = false
    @State private var columns = [GridItem(.adaptive(minimum: UIDevice.current.userInterfaceIdiom == .phone ? 150 : 250))]
    
    @State private var cardWidthiPhone: CGFloat = 150
    @State private var cardHeightiPhone: CGFloat = 230
    @State private var cardWidthiPad: CGFloat = 250
    @State private var cardHeightiPad: CGFloat = 350
        
    @State private var currentDevice = UIDevice.current.userInterfaceIdiom
    
    @State private var isConfirmDeletePresented: Bool = false
    
    // MARK: - MyNotesView body
    
    var body: some View
    {
        NavigationView
        {
            switch quickSettings.viewStylePreference
            {
                // MARK: - case .list
                case .list:
                    List
                    {
                        // This for loop displays the pinned notes
                        ForEach(searchResults)
                        {
                            noteEntity in
                            
                            if(noteEntity.isPinned)
                            {
                                NotesCellListView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                                    .transition(.scale)
                                    .swipeActions(edge: .leading, allowsFullSwipe: true)
                                    {
                                        Button(action: {
                                            withAnimation
                                            {
                                                noteEntity.isPinned.toggle()
                                                myNotesViewModel.updateNote()
                                            }
                                        })
                                        {
                                            Image(systemName: noteEntity.isPinned ? "pin.slash" : "pin")
                                        }
                                        .tint(.blue)
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true)
                                    {
                                        Button(action: {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                                            {
                                                withAnimation
                                                {
                                                    myNotesViewModel.deleteNoteByID(noteID: noteEntity.noteID!)
                                                }
                                            }
                                        })
                                        {
                                            Image(systemName: "trash")
                                        }
                                        .tint(.red)
                                    }
                                    .contextMenu
                                    {
                                        withAnimation
                                        {
                                            ContextMenuItems(myNotesVViewModel: myNotesViewModel, myNotesEntity: noteEntity, isGridView: false)
                                                .transition(.scale)
                                        }
                                    }
                            }
                        }
                        .onDelete(perform: myNotesViewModel.deleteNote)
                        
                        // This for loop displays the unpinned notes
                        ForEach(searchResults)
                        {
                            noteEntity in
                            
                            if(!noteEntity.isPinned)
                            {
                                NotesCellListView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                                    .transition(.scale)
                                    .swipeActions(edge: .leading, allowsFullSwipe: true)
                                    {
                                        Button(action: {
                                            withAnimation
                                            {
                                                noteEntity.isPinned.toggle()
                                                myNotesViewModel.updateNote()
                                            }
                                        })
                                        {
                                            Image(systemName: noteEntity.isPinned ? "pin.slash" : "pin")
                                        }
                                        .tint(.blue)
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true)
                                    {
                                        Button(action: {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                                            {
                                                withAnimation
                                                {
                                                    myNotesViewModel.deleteNoteByID(noteID: noteEntity.noteID!)
                                                }
                                            }
                                        })
                                        {
                                            Image(systemName: "trash")
                                        }
                                        .tint(.red)
                                    }
                                    .contextMenu
                                    {
                                        withAnimation
                                        {
                                            ContextMenuItems(myNotesVViewModel: myNotesViewModel, myNotesEntity: noteEntity, isGridView: false)
                                                .transition(.scale)
                                        }
                                    }
                            }
                        }
                        .onDelete(perform: myNotesViewModel.deleteNote)
                    }
                    .refreshable
                    {
                        myNotesViewModel.fetchNotes()
                    }
                    .listStyle(.insetGrouped)
                    .navigationTitle("My Notes Plus")
                    .searchable(text: $searchQuery)
                    .toolbar()
                    {
                        ToolbarItemGroup(placement: .navigationBarLeading)
                        {
                            editButton
                        }
                        
                        ToolbarItemGroup(placement: .navigationBarTrailing)
                        {
                            filterButton
                        }
                        
                        ToolbarItemGroup(placement: .bottomBar)
                        {
                            settingsButton_notesCount_NewNoteButton
                        }
                    }
                
                // MARK: - case .grid
                case .grid:
                    withAnimation
                    {
                        ScrollView
                        {
                            LazyVGrid(columns: columns, alignment: .center, spacing: 25)
                            {
                                //This for loop displays the pinned notes
                                ForEach(searchResults)
                                {
                                    noteEntity in
                                    
                                    if(noteEntity.isPinned)
                                    {
                                        NotesCellGridView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                                            .frame(width: currentDevice == .phone ? cardWidthiPhone : cardWidthiPad, height: currentDevice == .phone ? cardHeightiPhone : cardHeightiPad)
                                            .transition(.scale)
                                            .contextMenu
                                            {
                                                ContextMenuItems(myNotesVViewModel: myNotesViewModel, myNotesEntity: noteEntity, isGridView: true)
                                                    .transition(.scale)
                                            }
                                    }
                                }
                                .onDelete(perform: myNotesViewModel.deleteNote)
                                
                                //This for loop displays the unpinned notes
                                ForEach(searchResults)
                                {
                                    noteEntity in
                                    
                                    if(!noteEntity.isPinned)
                                    {
                                        NotesCellGridView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                                            .frame(width: currentDevice == .phone ? cardWidthiPhone : cardWidthiPad, height: currentDevice == .phone ? cardHeightiPhone : cardHeightiPad)
                                            .transition(.scale)
                                            .contextMenu
                                            {
                                                ContextMenuItems(myNotesVViewModel: myNotesViewModel, myNotesEntity: noteEntity, isGridView: true)
                                                    .transition(.scale)
                                            }
                                    }
                                }
                                .onDelete(perform: myNotesViewModel.deleteNote)
                            }
                            .refreshable
                            {
                                myNotesViewModel.fetchNotes()
                            }
                            .listStyle(.insetGrouped)
                            .navigationTitle("My Notes Plus")
                            .toolbar()
                            {
//                                ToolbarItemGroup(placement: .navigationBarLeading)
//                                {
//                                    editButton
//                                }
                                
                                ToolbarItemGroup(placement: .navigationBarTrailing)
                                {
                                    filterButton
                                }
                                
                                ToolbarItemGroup(placement: .bottomBar)
                                {
                                    settingsButton_notesCount_NewNoteButton
                                }
                            }
                        }
                        .searchable(text: $searchQuery)
                    }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - searchResults
    
    var searchResults: [MyNotesEntity]
    {
        if searchQuery == ""
        {
            return myNotesViewModel.noteEntities.filter
            {
                quickSettings.currentFilter.contains($0.noteTag!)
            }
        }
        
        else
        {
            return myNotesViewModel.noteEntities.filter
            {
                ($0.noteTitle!.lowercased().contains(searchQuery.lowercased()) || $0.noteText!.lowercased().contains(searchQuery.lowercased())) && quickSettings.currentFilter.contains($0.noteTag!)
            }
        }
    }
    
    // MARK: - editButton
    
    var editButton: some View
    {
        EditButton()
            .buttonStyle(.plain)
            .foregroundColor(.accentColor)
    }
    
    //MARK: - filterButton
    
    var filterButton: some View
    {
        Button(action: {
            showFilters.toggle()
        })
        {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .overlay(FilterButtonDot(filter: quickSettings))
        }
        .sheet(isPresented: $showFilters)
        {
            FilterSheet(quickSettings: quickSettings)
        }
        .buttonStyle(.plain)
        .foregroundColor(.accentColor)
    }
    
    // MARK: - settingsButton_notesCount_NewNoteButton
    
    var settingsButton_notesCount_NewNoteButton: some View
    {
        Group
        {
            Button(action: {
                showSettings.toggle()
            })
            {
                Image(systemName: "gear")
            }
            .sheet(isPresented: $showSettings)
            {
                SettingsSheet()
            }
            .buttonStyle(.plain)
            .foregroundColor(.accentColor)
            
            Spacer()
            
            Text(searchResults.count > 0 ? (searchResults.count == 1 ? "1 Note" : "\(searchResults.count) Notes") : "No Notes")
                .font(.caption2)
                .foregroundColor(.gray)
            
            Spacer()
            
            HStack
            {
                NavigationLink(destination: NewNoteView(myNotesViewModel: myNotesViewModel, myNotesEntity: MyNotesEntity(), noteID: UUID()))
                {
                    Image(systemName: "square.and.pencil")
                }
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
            }
        }
    }
}

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
                                
                                Text(noteEntity.noteText?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No Content")
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

// MARK: - NotesCellGridView

struct NotesCellGridView: View
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
    @State private var minWidthiPad: CGFloat = 250
    @State private var minHeightiPad: CGFloat = 350
    
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
                            shadowX = 1
                            shadowY = 1
                            shadowRadius = 1
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
                        {
                            isNavigationLinkActive = true
                        }
                    }
            }
            
            NavigationLink(destination: UpdateNoteView(myNotesViewModel: myNotesViewModel, myNotesEntity: noteEntity, noteTitle: noteEntity.noteTitle ?? "", originalNoteTitle: noteEntity.noteTitle ?? "", noteText: noteEntity.noteText ?? "", originalNoteText: noteEntity.noteText ?? "", noteTag: noteEntity.noteTag ?? "⚪️", originalNoteTag: noteEntity.noteTag ?? "⚪️"), isActive: $isNavigationLinkActive)
            {
                EmptyView()
            }
            .opacity(0)
            
            if noteEntity.noteText != nil && noteEntity.noteTitle != nil
            {
                if !noteEntity.noteText!.isEmpty || !noteEntity.noteTitle!.isEmpty
                {
                    VStack
                    {
                        VStack(alignment: .leading)
                        {
                            Text(noteEntity.noteTitle?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 ? "No Title" : noteEntity.noteTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No Title")
                                .font(currentDevice == .phone ? .caption : .body)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                
                            Divider()
                            
                            Text(noteEntity.noteText?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No Content")
                                    .lineLimit(10)
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
                    .padding(5)
                }
            }
        }
        .onAppear
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75)
            {
                withAnimation
                {
                    shadowX = 15
                    shadowY = 15
                    shadowRadius = 15
                }
            }
        }
        .onTapGesture
        {
            withAnimation
            {
                shadowX = 1
                shadowY = 1
                shadowRadius = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
            {
                isNavigationLinkActive = true
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - ContextMenuItems

struct ContextMenuItems: View
{
    @StateObject var myNotesVViewModel: MyNotesViewModel
    @State var myNotesEntity: MyNotesEntity
    @State var isGridView: Bool
    
    // MARK: - ContextMenuItems body
    
    var body: some View
    {
        Group
        {
            if(isGridView)
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
            
//            Divider()
            
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
            
//            Divider()
            
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

// MARK: - FilterButtonDot

struct FilterButtonDot: View
{
    @StateObject var filter: QuickSettingsClass
    
    var body: some View
    {
        Text(filter.currentFilter == "🔴🟢🔵🟡⚪️" ? "" : filter.currentFilter)
            .frame(width: 30)
            .font(.subheadline)
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        MyNotesView(myNotesViewModel: MyNotesViewModel(), quickSettings: QuickSettingsClass())
//            .preferredColorScheme(.dark)
    }
}
