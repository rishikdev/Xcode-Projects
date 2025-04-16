//
//  SearchView.swift
//  My Kitchen
//
//  Created by Rishik Dev on 31/01/22.
//

import SwiftUI

struct SearchView: View
{
    var body: some View
    {
        SearchTabView()
    }
}

let searchNavigationText: String = "Search"

struct SearchNavView: View
{
    let names = ["Holly Hanes", "Josh", "Rhonda", "Ted"]
    
    @State private var searchQuery: String = ""
//    @StateObject var groceryListViewModel = GroceryListViewModel()
    
    var searchResults: [String]
    {
        if searchQuery.isEmpty
        {
            return names
        }
        
        else
        {
            return names.filter{ $0.contains(searchQuery) }
        }
    }
    
    var body: some View
    {
        NavigationView
        {
            List
            {
                ForEach(searchResults, id: \.self)
                {
                    result in
                    NavigationLink(destination: Text(result))
                    {
                        Text(result)
                    }
                }
            }
            .searchable(text: $searchQuery)
            .onChange(of: searchQuery)
            {
                newValue in
                
            }
            .navigationTitle(searchNavigationText)
        }
    }
}

struct SearchTabView: View
{
    var body: some View
    {
        SearchNavView().tabItem
        {
            HStack
            {
                Image(systemName: "magnifyingglass")
                Text(searchNavigationText)
            }
        }
        .tag(searchNavigationText)
    }
}

struct SearchView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SearchView()
    }
}
