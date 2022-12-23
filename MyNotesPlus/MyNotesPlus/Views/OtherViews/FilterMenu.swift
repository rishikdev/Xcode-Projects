//
//  FilterMenu.swift
//  My Notes
//
//  Created by Rishik Dev on 19/03/22.
//

import SwiftUI

struct FilterMenu: View
{
    @Environment(\.colorScheme) var colourScheme
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var quickSettings: QuickSettingsClass
    
    var body: some View
    {
        VStack
        {
            Section(header: Text("Filter by"))
            {
                ScrollView
                {
                    ForEach(["🔴 Red", "🟢 Green", "🔵 Blue", "🟡 Yellow", "⚪️ White"], id: \.self)
                    {
                        buttonText in
                        
                        Button(action: {
                            withAnimation
                            {
                                quickSettings.currentFilter = String(buttonText.split(separator: " ")[0])
                                dismiss()
                            }
                        })
                        {
                            HStack
                            {
                                Text(buttonText)
                                Spacer()
                                
                                if(quickSettings.currentFilter == String(buttonText.split(separator: " ")[0]))
                                {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        withAnimation
                        {
                            quickSettings.currentFilter = "🔴🟢🔵🟡⚪️"
                            dismiss()
                        }
                    })
                    {
                        HStack
                        {
                            Text("Show All")
                            
                            Spacer()
                            
                            if(quickSettings.currentFilter == "🔴🟢🔵🟡⚪️")
                            {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct FilterSheet_Previews: PreviewProvider
{
    static var previews: some View
    {
        FilterMenu(quickSettings: QuickSettingsClass())
    }
}
