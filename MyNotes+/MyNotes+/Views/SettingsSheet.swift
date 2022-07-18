//
//  SettingsView.swift
//  My Notes
//
//  Created by Rishik Dev on 31/03/22.
//

import SwiftUI

struct SettingsSheet: View
{
//    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colourScheme
    @Environment(\.openURL) var openURL
    
    @StateObject var quickSettings = QuickSettingsClass()
    @StateObject var myNotesViewMode = MyNotesViewModel()
    
    var body: some View
    {
        VStack
        {
            Form
            {
                Section(header: Text("Authentication"),footer: Text("To use biometric authentication (Touch ID or Face ID), please make sure that Touch ID or Face ID is enabled in your device's Settings app."))
                {
                    Toggle("Use Biometric Authentication", isOn: $quickSettings.isUsingBiometric)
                }
                .foregroundColor(colourScheme == .light ? .black : .white)
                
                Section(header: Text("View Style"))
                {
                    VStack
                    {
                        Picker("View Style", selection: quickSettings.$viewStylePreference)
                        {
                            ForEach(ViewStyleEnum.allCases, id: \.self)
                            {
                                Image(systemName: $0.imageName)
                            }
                        }
                        #if !os(watchOS)
                        .pickerStyle(.segmented)
                        #endif
                        
                        HStack
                        {
                            Spacer()
                            
                            Text("List")
                            
                            Spacer()
                            Spacer()
                            
                            Text("Grid")
                            
                            Spacer()
                        }
                        .font(.callout)
                    }
                }
                .foregroundColor(colourScheme == .light ? .black : .white)
                
                Section(header: Text("Support").foregroundColor(colourScheme == .light ? .black : .white))
                {
                    List
                    {
                        Button("Visit Website")
                        {
                            openURL(URL(string: "https://rishikdev.github.io/MyNotes")!)
                        }
                        
                        Button("Privacy Policy")
                        {
                            openURL(URL(string: "https://rishikdev.github.io/MyNotes/PrivacyPolicy")!)
                        }
                        
                        Button("Contact Us")
                        {
                            openURL(URL(string: "https://rishikdev.github.io/MyNotes/ContactUs")!)
                        }
                    }
                }
                
                Section(header: Text("iCloud Synchronisation"), footer: Text("Make sure you are signed in to your iCloud account on all devices, and Background App Refresh is turned on. You can find this option in Settings -> My Notes Plus."))
                {
                    
                }
                .foregroundColor(colourScheme == .light ? .black : .white)
            }
            .onChange(of: quickSettings.isUsingBiometric)
            {
                isNoteLocked in
//                myNotesViewMode.isAppLocked = isNoteLocked
            }
        }
    }
}

enum ViewStyleEnum: String, CaseIterable
{
    case list = "List"
    case grid = "Grid"
    
    var imageName: String
    {
        switch self
        {
            case .list:
                return "list.dash"
            case .grid:
                return "square.grid.2x2"
        }
    }
}

struct SettingsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SettingsSheet()
    }
}
