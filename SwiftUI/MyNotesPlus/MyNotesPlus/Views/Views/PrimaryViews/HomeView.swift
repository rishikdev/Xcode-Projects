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
struct HomeView: View {    
    @Environment(\.colorScheme) var colourScheme
    
    @ObservedObject var myNotesViewModel: MyNotesViewModel
    @ObservedObject var quickSettings: QuickSettingsClass
    
    @State private var showFilters: Bool = false
    @State private var showSettings: Bool = false
    @State private var searchQuery: String = ""
    
    @State private var cardWidthiPhone: CGFloat = 150
    @State private var cardHeightiPhone: CGFloat = 230
    @State private var cardWidthiPad: CGFloat = 250
    @State private var cardHeightiPad: CGFloat = 350
        
    @State private var currentDevice = UIDevice.current.userInterfaceIdiom
    
    @State private var isConfirmDeletePresented: Bool = false
    @State private var activateNewNoteView: Bool = false
    
    // MARK: - MyNotesView body
    var body: some View {
        NavigationView {
            VStack {
                switch quickSettings.viewStylePreference {
                    // MARK: - case .list
                case .list:
                    if(myNotesViewModel.isAnyNotePinned()) {
                        // MARK: Section List View
                        SectionedListView(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
                    } else {
                        // MARK: Non Section List View
                        NonSectionedListView(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
                    }
                    
                    // MARK: - case .card
                case .card:
                    NotesCardView(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
                }
                
                // MARK: - Bottom buttons
                HStack {
                    settingsButton
                    Spacer()
                    notesCount
                    Spacer()
                    newNoteButton
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .onChange(of: quickSettings.isUsingBiometric) { _ in
                myNotesViewModel.fetchNotes()
            }
            .toolbar() {
                ToolbarItem(placement: .navigationBarTrailing) {
                    filterButton
                }
            }
            .navigationTitle("My Notes Plus")
            
            if(myNotesViewModel.noteEntities.isEmpty) {
                Text("No notes")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            } else {
                Text("Select a note")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
        }
        .customNavigationViewStyle(if: quickSettings.viewStylePreference == .card, then: StackNavigationViewStyle(), else: ColumnsNavigationViewStyle())
    }
    
    //MARK: - filterButton
    var filterButton: some View {
        VStack {
            Menu {
                FilterMenu(quickSettings: quickSettings)
                Divider()
                SortByMenu(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
            } label: {
                Image(systemName: "ellipsis.circle")
                    .overlay(FilterButtonDot(quickSettings: quickSettings))
                    .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - searchResults
//    var searchResults: [MyNotesEntity] {
//        if(searchQuery == "") {
//            return myNotesViewModel.noteEntities.filter {
//                quickSettings.currentFilter.contains($0.noteTag!)
//            }
//        } else {
//            return myNotesViewModel.noteEntities.filter {
//                ($0.noteTitle!.lowercased().contains(searchQuery.lowercased()) || $0.noteText!.lowercased().contains(searchQuery.lowercased())) && quickSettings.currentFilter.contains($0.noteTag!)
//            }
//        }
//    }
    
    // MARK: - settingsButton
    var settingsButton: some View {
        SettingsButton(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
    }
    
    // MARK: - notesCount
    var notesCount: some View {
        Text(GlobalFunctions.shared.searchResults(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings, searchQuery: searchQuery).count > 0 ? ("^[\(GlobalFunctions.shared.searchResults(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings, searchQuery: searchQuery).count) Note](inflect: true)") : "No Notes")
            .font(.caption2)
            .foregroundColor(.gray)
    }
    
    // MARK: - newNoteButton
    var newNoteButton: some View {
        NavigationLink(destination: NewNoteView(myNotesViewModel: myNotesViewModel,
                                                noteEntity: MyNotesEntity(),
                                                noteID: UUID()),
                       isActive: $activateNewNoteView) {
            Image(systemName: "square.and.pencil")
                .onTapGesture {
                    myNotesViewModel.didUserDeleteNote = false
                    activateNewNoteView = true
                }
                .font(.title2)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(myNotesViewModel: MyNotesViewModel(), quickSettings: QuickSettingsClass())
            .previewDisplayName("Light Mode")
        
        HomeView(myNotesViewModel: MyNotesViewModel(), quickSettings: QuickSettingsClass())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}
