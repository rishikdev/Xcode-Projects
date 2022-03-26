//
//  FilterModal.swift
//  My Notes
//
//  Created by Rishik Dev on 19/03/22.
//

import SwiftUI

struct FilterSheet: View
{
    @Environment(\.colorScheme) var colourScheme
    @Environment(\.dismiss) var dismiss
    @ObservedObject var filter: FilterClass
    
    var body: some View
    {
        VStack
        {
            HStack
            {
                Button(action: { dismiss() })
                {
                    Text("Cancel")
                }
                .padding()
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
                
                Spacer()
            }
            
            List
            {
                ForEach(["🔴 Red", "🟢 Green", "🔵 Blue", "🟡 Yellow", "⚪️ White"], id: \.self)
                {
                    buttonText in
                    
                    Button(action: {
                        filter.currentFilter = String(buttonText.split(separator: " ")[0])
                        dismiss()
                    })
                    {
                        HStack
                        {
                            Text(buttonText)
                            Spacer()
                            
                            if(filter.currentFilter == String(buttonText.split(separator: " ")[0]))
                            {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
                              
                Button(action: {
                    filter.currentFilter = "🔴🟢🔵🟡⚪️"
                    dismiss()
                })
                {
                    HStack
                    {
                        Text("Show All")
                        
                        Spacer()
                        
                        if(filter.currentFilter == "🔴🟢🔵🟡⚪️")
                        {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            .foregroundColor(colourScheme == .light ? .black : .white)
            .listStyle(.insetGrouped)
        }
    }
}

struct FilterModal_Previews: PreviewProvider
{
    static var previews: some View
    {
        FilterSheet(filter: FilterClass())
    }
}
