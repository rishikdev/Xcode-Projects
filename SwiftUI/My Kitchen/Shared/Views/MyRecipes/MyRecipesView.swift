//
//  MyRecipesView.swift
//  My Kitchen
//
//  Created by Rishik Dev on 29/01/22.
//

import SwiftUI

struct MyRecipesView: View
{
    var body: some View
    {
        MyRecipesTabView()
    }
}

let myRecipesNavigationText: String = "My Recipes"

struct MyRecipesNavView: View
{
    var body: some View
    {
        NavigationView
        {
            ZStack
            {
                Text("Recipe List is coming soon!")
            }
            .navigationTitle(myRecipesNavigationText)
        }
    }
}

struct MyRecipesTabView: View
{
    var body: some View
    {
        MyRecipesNavView().tabItem
        {
            HStack
            {
                Image(systemName: "menucard.fill")
                Text(myRecipesNavigationText)
            }
        }
        .tag(myRecipesNavigationText)
    }
}

struct MyRecipesView_Previews: PreviewProvider
{
    static var previews: some View
    {
        MyRecipesView()
    }
}
