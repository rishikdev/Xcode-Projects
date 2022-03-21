//
//  FilterModal.swift
//  My Notes
//
//  Created by Rishik Dev on 19/03/22.
//

import SwiftUI

struct FilterModal: View
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
                Button(action: {
                    filter.currentFilter = "🔴"
                    dismiss()
                })
                {
                    HStack
                    {
                        Text("🔴 Red")
                        
                        Spacer()
                        
                        if(filter.currentFilter == "🔴")
                        {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button(action: {
                    filter.currentFilter = "🟢"
                    dismiss()
                })
                {
                    HStack
                    {
                        Text("🟢 Green")
                        
                        Spacer()
                        
                        if(filter.currentFilter == "🟢")
                        {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button(action: {
                    filter.currentFilter = "🔵"
                    dismiss()
                })
                {
                    HStack
                    {
                        Text("🔵 Blue")
                        
                        Spacer()
                        
                        if(filter.currentFilter == "🔵")
                        {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button(action: {
                    filter.currentFilter = "🟡"
                    dismiss()
                })
                {
                    HStack
                    {
                        Text("🟡 Yellow")
                        
                        Spacer()
                        
                        if(filter.currentFilter == "🟡")
                        {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button(action: {
                    filter.currentFilter = "⚪️"
                    dismiss()
                })
                {
                    HStack
                    {
                        Text("⚪️ White")
                        
                        Spacer()
                        
                        if(filter.currentFilter == "⚪️")
                        {
                            Image(systemName: "checkmark")
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
        FilterModal(filter: FilterClass())
    }
}
