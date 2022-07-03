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
                
                Section(header: Text("iCloud Synchronisation"), footer: Text("Make sure you are signed in to your iCloud account on all devices, and Background App Refresh is turned on under Settings -> My Notes Plus."))
                {
                    
                }
                .foregroundColor(colourScheme == .light ? .black : .white)
            }
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
