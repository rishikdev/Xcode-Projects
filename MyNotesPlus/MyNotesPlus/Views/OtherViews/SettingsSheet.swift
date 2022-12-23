//
//  SettingsView.swift
//  My Notes
//
//  Created by Rishik Dev on 31/03/22.
//

import SwiftUI

struct SettingsSheet: View
{
    @Environment(\.colorScheme) var colourScheme
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss
    
    @StateObject var myNotesViewModel: MyNotesViewModel
    @StateObject var quickSettings: QuickSettingsClass
    
    var body: some View
    {
        VStack
        {
            #if !os(watchOS)
            HStack
            {
                Button(action: {
                    dismiss()
                })
                {
                    Text("Dismiss")
                }
                .padding(.leading, 10)
                .padding(.top, 10)
                
                Spacer()
            }
            #endif
            
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
                        .onChange(of: quickSettings.viewStylePreference)
                        {
                            _ in
                            dismiss()
                        }
                        
                        HStack
                        {
                            Spacer()
                            
                            Text("List")
                            
                            Spacer()
                            Spacer()
                            
                            Text("Card")
                            
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
                            openURL(URL(string: "https://rishikdev.github.io/MyNotesPlus/")!)
                        }
                        
                        Button("Privacy Policy")
                        {
                            openURL(URL(string: "https://rishikdev.github.io/MyNotesPlus/PrivacyPolicy.html")!)
                        }
                        
                        Button("Contact Us")
                        {
                            openURL(URL(string: "https://rishikdev.github.io/MyNotesPlus/ContactUs.html")!)
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
                isAppLocked in
                
                /// Changing the card colour (or any other existing property) of the note was the only way I was able to force the widget to update.
                /// Adding a new property (isNoteLocked) to the existing entity did not work for some reason.
                
                for entity in myNotesViewModel.noteEntities
                {
                    entity.noteCardColour = isAppLocked ? entity.noteCardColour! + "-LOCKED" : String(entity.noteCardColour!.split(separator: "-")[0])
                    
                    myNotesViewModel.updateNote()
                }
            }
        }
    }
}

enum ViewStyleEnum: String, CaseIterable
{
    case list = "List"
    case card = "Card"
    
    var imageName: String
    {
        switch self
        {
            case .list:
                return "list.dash"
            case .card:
                return "square.grid.2x2"
        }
    }
}

struct SettingsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SettingsSheet(myNotesViewModel: MyNotesViewModel(), quickSettings: QuickSettingsClass())
    }
}
