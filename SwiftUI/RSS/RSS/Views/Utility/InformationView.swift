//
//  InformationView.swift
//  RSS
//
//  Created by Rishik Dev on 15/01/2025.
//

import SwiftUI

struct InformationView: View {
    let primaryText: String
    var secondaryText: String = ""
    var primaryTextForegroundColor: Color = .secondary
    var secondaryTextForegroundColor: Color = .secondary
    
    var body: some View {
        VStack(spacing: 0) {
            Text(primaryText)
                .font(.title)
                .fontWeight(.black)
                .foregroundStyle(primaryTextForegroundColor)
            
            Text(secondaryText)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .foregroundStyle(secondaryTextForegroundColor)
        }
        .fontDesign(.rounded)
        .padding()
    }
}

#Preview {
    InformationView(primaryText: "Primary text", secondaryText: "Secondary text")
}
