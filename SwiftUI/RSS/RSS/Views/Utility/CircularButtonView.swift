//
//  CircularButtonView.swift
//  RSS
//
//  Created by Rishik Dev on 26/02/2025.
//

import SwiftUI

struct CircularButtonView: View {
    let text: String
    let systemImage: String
    var tint: Color = .blue
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Label(text, systemImage: systemImage)
                .labelStyle(.iconOnly)
                .frame(width: 24, height: 24)
        }
        .buttonStyle(.bordered)
        .tint(tint)
        .clipShape(.circle)
    }
}

#Preview {
    CircularButtonView(text: "Outlets",
                       systemImage: "list.bullet",
                       tint: .blue,
                       action: { })
}
