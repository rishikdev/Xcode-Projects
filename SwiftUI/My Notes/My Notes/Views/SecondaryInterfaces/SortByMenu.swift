//
//  SortByMenu.swift
//  My Notes
//
//  Created by Rishik Dev on 22/12/22.
//

import SwiftUI

struct SortByMenu: View
{
    @Environment(\.dismiss) var dismiss
    @StateObject var myNotesViewModel: MyNotesViewModel
    @StateObject var quickSettings: QuickSettingsClass
    
    var body: some View
    {
        Section(header: Text("Sort by"))
        {
            ForEach(SortByEnum.allCases, id: \.self)
            {
                sortBy in
                
                Button(action: {
                    withAnimation
                    {
                        applySorting(sortBy: sortBy)
                    }
                })
                {
                    HStack
                    {
                        Text(sortBy.rawValue)
                        
                        if(quickSettings.currentSortByKey == sortBy.key)
                        {
                            Image(systemName: quickSettings.sortInAscending ? "chevron.up" : "chevron.down")
                        }
                    }
                }
            }
        }
    }
    
    func applySorting(sortBy: SortByEnum)
    {
        if(quickSettings.currentSortByKey == sortBy.key)
        {
            quickSettings.sortInAscending = !quickSettings.sortInAscending
        }
        
        quickSettings.currentSortByKey = sortBy.key
        myNotesViewModel.fetchNotes()
    }
}

enum SortByEnum: String, CaseIterable
{
    case noteDate = "Date"
    case noteTitle = "Title"
    
    var key: String
    {
        switch self
        {
            case .noteDate:
                return "noteDate"
            
            case .noteTitle:
                return "noteTitle"
        }
    }
}

struct SortByMenu_Previews: PreviewProvider
{
    static var previews: some View
    {
        SortByMenu(myNotesViewModel: MyNotesViewModel(), quickSettings: QuickSettingsClass())
    }
}
