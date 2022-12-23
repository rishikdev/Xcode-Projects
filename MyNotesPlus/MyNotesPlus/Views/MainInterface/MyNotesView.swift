//
//  ContentView.swift
//  MyNotes+
//
//  Created by Rishik Dev on 11/06/22.
//

#if !os(watchOS)
import LocalAuthentication
#endif
import SwiftUI

// MARK: - MyNotesView

struct MyNotesView: View
{
    @Environment(\.colorScheme) var colourScheme
    
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
    @State private var activateNewNoteView: Bool = false
        
    // MARK: - MyNotesView body
    
    var body: some View
    {
        NavigationView
        {
            VStack
            {
                switch quickSettings.viewStylePreference
                {
                    // MARK: - case .list
                    case .list:
                        withAnimation
                        {
                            Group
                            {
                                // MARK: - Section View
                                if(myNotesViewModel.isAnyNotePinned())
                                {
                                    MyNotesSectionView(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
                                }
                                
                                // MARK: - Non Section View
                                else
                                {
                                    MyNotesNonSectionView(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
                                }
                            }
                        }
                    
                    // MARK: - case .card
                    case .card:
                        withAnimation
                        {
                            ScrollView
                            {
                                LazyVGrid(columns: columns, alignment: .center, spacing: 40)
                                {
                                    // MARK: - Pinned notes
                                    ForEach(searchResults)
                                    {
                                        noteEntity in
                                        
                                        if(noteEntity.isPinned)
                                        {
                                            NotesCellCardView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                                                .modifier(CardViewModifierCollection(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity))
                                        }
                                    }
                                    
                                    // MARK: - Unpinned notes
                                    ForEach(searchResults)
                                    {
                                        noteEntity in
                                        
                                        if(!noteEntity.isPinned)
                                        {
                                            NotesCellCardView(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity)
                                                .modifier(CardViewModifierCollection(myNotesViewModel: myNotesViewModel, noteEntity: noteEntity))
                                        }
                                    }
                                }
                                .padding(.bottom)
                                .listStyle(.insetGrouped)
                            }
                            .refreshable
                            {
                                myNotesViewModel.fetchNotes()
                            }
                            .searchable(text: $searchQuery)
//                            .navigationViewStyle(.stack)
                        }
                }
                
                // MARK: - Bottom buttons
                HStack
                {
                    settingsButton
                    Spacer()
                    notesCount
                    Spacer()
                    newNoteButton
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .onChange(of: quickSettings.isUsingBiometric)
            {
                _ in
                myNotesViewModel.fetchNotes()
            }
            .toolbar()
            {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    filterButton
                }
            }
            .navigationTitle("My Notes Plus")
            
            if(myNotesViewModel.noteEntities.isEmpty)
            {
                Text("No notes")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
            
            else
            {
                Text("Select a note")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
        }
        .customNavigationViewStyle(if: quickSettings.viewStylePreference == .card, then: StackNavigationViewStyle(), else: ColumnsNavigationViewStyle())
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
    
    //MARK: - filterButton
    
    var filterButton: some View
    {
        VStack
        {
            Menu
            {
                FilterMenu(quickSettings: quickSettings)
                Divider()
                SortByMenu(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
            }
            label:
            {
                Image(systemName: "ellipsis.circle")
                    .overlay(FilterButtonDot(filter: quickSettings))
                    .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - settingsButton
    
    var settingsButton: some View
    {
        Button(action: {
            showSettings.toggle()
        })
        {
            Image(systemName: "gear")
                .font(.title2)
        }
        .sheet(isPresented: $showSettings)
        {
            SettingsSheet(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
        }
    }
    
    // MARK: - notesCount
    
    var notesCount: some View
    {
        Text(searchResults.count > 0 ? (searchResults.count == 1 ? "1 Note" : "\(searchResults.count) Notes") : "No Notes")
            .font(.caption2)
            .foregroundColor(.gray)
    }
    
    // MARK: - newNoteButton
    
    var newNoteButton: some View
    {
        NavigationLink(destination: NewNoteView(myNotesViewModel: myNotesViewModel, noteEntity: MyNotesEntity(), noteID: UUID()),
                       isActive: $activateNewNoteView)
        {
            Image(systemName: "square.and.pencil")
                .onTapGesture
                {
                    myNotesViewModel.didUserDeleteNote = false
                    activateNewNoteView = true
                }
                .font(.title2)
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

// MARK: - Custom ListViewModifierCollection

struct ListViewModifierCollection: ViewModifier
{
    let myNotesViewModel: MyNotesViewModel
    let noteEntity: MyNotesEntity
    
    func body(content: Content) -> some View
    {
        content
            .swipeActions(edge: .leading, allowsFullSwipe: true)
            {
                Button(action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                    {
                        withAnimation
                        {
                            noteEntity.isPinned.toggle()
                            myNotesViewModel.updateNote()
                        }
                    }
                })
                {
                    Label(noteEntity.isPinned ? "Unpin" : "pin", systemImage: noteEntity.isPinned ? "pin.slash" : "pin")
                }
                .tint(.blue)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true)
            {
                Button(role: .destructive, action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                    {
                        withAnimation
                        {
                            myNotesViewModel.deleteNoteByID(noteID: noteEntity.noteID!)
                            myNotesViewModel.didUserDeleteNote.toggle()
                        }
                    }
                })
                {
                    Image(systemName: "trash")
                }
            }
            .contextMenu
            {
                withAnimation
                {
                    ContextMenuItems(myNotesViewModel: myNotesViewModel, myNotesEntity: noteEntity, isCardView: false)
                        .transition(.scale)
                }
            }
    }
}

// MARK: - Custom CardViewModifierCollection

struct CardViewModifierCollection: ViewModifier
{
    let cardWidthiPhone: CGFloat = 150
    let cardHeightiPhone: CGFloat = 230
    let cardWidthiPad: CGFloat = 250
    let cardHeightiPad: CGFloat = 350
        
    let currentDevice = UIDevice.current.userInterfaceIdiom
    
    let myNotesViewModel: MyNotesViewModel
    let noteEntity: MyNotesEntity
    
    func body(content: Content) -> some View
    {
        content
            .frame(width: currentDevice == .phone ? cardWidthiPhone : cardWidthiPad, height: currentDevice == .phone ? cardHeightiPhone : cardHeightiPad)
            .transition(.scale)
            .contextMenu
            {
                ContextMenuItems(myNotesViewModel: myNotesViewModel, myNotesEntity: noteEntity, isCardView: true)
                    .transition(.scale)
            }
    }
}

// MARK: - View extension customNavigationViewStyle

extension View
{
    public func customNavigationViewStyle<T, U>(if condition: Bool, then modifierT: T, else modifierU: U) -> some View where T: ViewModifier, U: ViewModifier
    {
        Group
        {
            if(condition)
            {
                modifier(modifierT)
            }
            
            else
            {
                modifier(modifierU)
            }
        }
    }
}

// MARK: - ColumnsNavigationViewStyle

struct ColumnsNavigationViewStyle: ViewModifier
{
    func body(content: Content) -> some View {
        content.navigationViewStyle(.columns)
    }
}

// MARK: - StackNavigationViewStyle

struct StackNavigationViewStyle: ViewModifier
{
    func body(content: Content) -> some View {
        content.navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        MyNotesView(myNotesViewModel: MyNotesViewModel(), quickSettings: QuickSettingsClass())
            .previewDisplayName("Light Mode")
//            .previewInterfaceOrientation(.landscapeLeft)
        
        MyNotesView(myNotesViewModel: MyNotesViewModel(), quickSettings: QuickSettingsClass())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}
