//
//  TintedButtonView.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import SwiftUI

struct TintedButtonView: View {
    var text: LocalizedStringResource = "Placeholder Button Text"
    var image: Image?
    var tint: Color = .blue
    var action: () -> Void = { }
    
    var body: some View {
        Button(action: { action() }) {
            HStack {
                if let image {
                    image
                }
                
                Text(text)
            }
        }
        .buttonStyle(.bordered)
        .tint(tint)
        .clipShape(.rect(cornerRadius: Constants.CornerRadius.small.rawValue))
    }
}

#Preview {
    TintedButtonView(text: "Dismiss",
                     image: Image(systemName: "xmark"),
                     tint: .red)
}
