//
//  FilterButtonDot.swift
//  MyNotesPlus
//
//  Created by Rishik Dev on 13/07/23.
//

import SwiftUI

struct FilterButtonDot: View {
    @ObservedObject var quickSettings: QuickSettingsClass
    
    var body: some View {
        Text(quickSettings.currentFilter == "🔴🟢🔵🟡⚪️" ? "" : quickSettings.currentFilter)
            .frame(width: 30)
            .font(.subheadline)
    }
}

struct FilterButtonDot_Previews: PreviewProvider {
    static var previews: some View {
        FilterButtonDot(quickSettings: QuickSettingsClass())
    }
}
