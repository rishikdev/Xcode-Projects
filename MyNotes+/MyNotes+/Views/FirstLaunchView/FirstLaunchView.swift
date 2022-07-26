//
//  FirstLaunchView.swift
//  My Notes
//
//  Created by Rishik Dev on 02/04/22.
//

import SwiftUI

struct FirstLaunchView: View
{
    @StateObject var myNotesViewModel: MyNotesViewModel
     let screenWidth = UIScreen.main.bounds.size.width
    @State var currentTab: Int = 0
    
    var body: some View
    {
        TabView(selection: $currentTab)
        {
            ZerothTabView(currentTab: $currentTab)
                .tag(0)
            
            FirstTabVIew(currentTab: $currentTab)
                .tag(1)
            
            SecondTabView(currentTab: $currentTab)
                .tag(2)
            
            ThirdTabView(myNotesViewModel: myNotesViewModel)
                .tag(3)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .minimumScaleFactor(0.7)
        .ignoresSafeArea()
    }
}

struct FirstLaunchView_Previews: PreviewProvider
{
    static var previews: some View
    {
        FirstLaunchView(myNotesViewModel: MyNotesViewModel())
    }
}
