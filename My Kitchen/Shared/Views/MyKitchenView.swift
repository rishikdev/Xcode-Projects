//
//  ContentView.swift
//  Shared
//
//  Created by Rishik Dev on 29/01/22.
//

import SwiftUI

struct MyKitchenView: View
{
//    @StateObject var groceryListViewModel = GroceryListViewModel()
    @State var selectedTab: String = "My Recipes"
    
    var body: some View
    {
        VStack
        {
            TabView(selection: $selectedTab)
            {
                GroceryListView()
                
                MyRecipesView()
                
                InventoryView()
                
                SearchView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        MyKitchenView()
//        My_KitchenView().preferredColorScheme(.dark).environmentObject(GroceryListViewModel())
        
        MyKitchenView().previewDevice("iPhone SE (2nd generation)").environmentObject(GroceryListViewModel())
        
//        My_KitchenView().previewDevice("iPhone SE (2nd generation)").preferredColorScheme(.dark).environmentObject(GroceryListViewModel())
    }
}
