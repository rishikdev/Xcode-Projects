//
//  FirstLaunchView.swift
//  My Notes
//
//  Created by Rishik Dev on 02/04/22.
//

import SwiftUI

struct FirstLaunchView: View
{
    @Environment(\.dismiss) var dismiss
    @StateObject var myNotesViewModel: MyNotesViewModel
    @StateObject var checkAppVersion: CheckApplicationVersion
    @State var currentTab: Int = 1
    
    var body: some View
    {
        TabView(selection: $currentTab)
        {
            FirstTabView(currentTab: $currentTab).tag(1)
            SecondTabView(currentTab: $currentTab).tag(2)
            ThirdTabView(currentTab: $currentTab, myNotesViewModel: myNotesViewModel, checkAppVersion: checkAppVersion).tag(3)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .ignoresSafeArea()
    }
}

struct FirstLaunchView_Previews: PreviewProvider
{
    static var previews: some View
    {
        FirstLaunchView(myNotesViewModel: MyNotesViewModel(), checkAppVersion: CheckApplicationVersion())
    }
}
