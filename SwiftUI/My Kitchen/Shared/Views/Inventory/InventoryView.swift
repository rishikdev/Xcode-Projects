//
//  InventoryView.swift
//  My Kitchen
//
//  Created by Rishik Dev on 29/01/22.
//

import SwiftUI

struct InventoryView: View
{
    var body: some View
    {
        InventoryTabView()
    }
}

let inventoryNavigationText: String = "Inventory"

struct InventoryNavView: View
{
    var body: some View
    {
        NavigationView
        {
            ZStack
            {
                Text("Inventory is coming soon!")
            }
            .navigationTitle(inventoryNavigationText)
        }
    }
}

struct InventoryTabView: View
{
    var body: some View
    {
        InventoryNavView().tabItem
        {
            HStack
            {
                Image(systemName: "archivebox.fill")
                Text(inventoryNavigationText)
            }
        }
        .tag(inventoryNavigationText)
    }
}

struct InventoryView_Previews: PreviewProvider
{
    static var previews: some View
    {
        InventoryView()
    }
}
