//
//  GroceryListView.swift
//  My Kitchen
//
//  Created by Rishik Dev on 29/01/22.
//

import SwiftUI

struct GroceryListView: View
{
    var body: some View
    {
        GroceryListTabView()
    }
}

let groceryListNavigationText: String = "Grocery Lists"

struct GroceryListNavView: View
{
    @StateObject var groceryListViewModel = GroceryListViewModel()
    
    var body: some View
    {
        NavigationView
        {
            List
            {
                ForEach(groceryListViewModel.savedEntities)
                {
                    entity in
                    
                    ZStack(alignment: .leading)
                    {
                        NavigationLink(destination: UpdateListView(groceryListViewModel: groceryListViewModel, groceryListEntity: entity, listTitle: entity.listTitle ?? "", listContent: entity.listContent ?? ""))
                        {
                            // used to disable detail descriptor arrows
                            EmptyView()
                        }
                        .opacity(0)
                        
                        VStack(alignment: .leading)
                        {
                            if !entity.listTitle!.isEmpty
                            {
                                Text(entity.listTitle!)
                                    .font(.headline)
                            }

                            else
                            {
                                Text("No Title")
                                    .font(.headline)
                            }
                            
                            if !entity.listContent!.isEmpty
                            {
                                Text(entity.listContent ?? "")
                                    .lineLimit(1)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            else
                            {
                                Text("No Additional Content")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                        }
                    }
                }
                .onDelete(perform: groceryListViewModel.deleteItem)  // used to delete a list from the list view
//                .onMove(perform: groceryListViewModel.moveItem)  // used to enable reordering
                
            }
            .listStyle(.insetGrouped)
            .navigationTitle(groceryListNavigationText)
            .toolbar
            {
                ToolbarItem(placement: .navigationBarLeading)
                {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    NavigationLink(destination: NewListView(groceryListViewModel: groceryListViewModel))
                    {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}

struct GroceryListTabView: View
{
    var body: some View
    {
        GroceryListNavView().tabItem
        {
            HStack
            {
                Image(systemName: "list.number")
                Text(groceryListNavigationText)
            }
        }
        .tag(groceryListNavigationText)
    }
}

struct GroceryListView_Previews: PreviewProvider
{
    static var previews: some View
    {
        GroceryListView()
    }

}
