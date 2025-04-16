//
//  RequirementsTextView.swift
//  Pickleball
//
//  Created by Rishik Dev on 18/11/24.
//

import SwiftUI

struct RequirementsTextView: View {
    var statusImage: Image
    var text: LocalizedStringResource
    var foregroundColour: Color
    
    var body: some View {
        HStack() {
            statusImage
            Text(verbatim: text.key)
        }
        .foregroundStyle(foregroundColour)
        .font(.caption)
    }
}

#Preview {
    RequirementsTextView(statusImage: Image(systemName: "info.circle"),
                         text: "Requirements",
                         foregroundColour: .gray)
}
