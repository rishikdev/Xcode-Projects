//
//  AuthenticationButtonView.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import SwiftUI

struct AuthenticationButtonView: View {
    var text: LocalizedStringResource = "Placeholder Button Text"
    var image: Image?
    var textColour: Color = .white
    var tint: Color = .blue
    var action: () -> Void = { }
    
    var body: some View {
        Button(action: { action() }) {
            HStack {
                if let image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 13)
                }
                
                Text(text)
                    .font(.system(size: 19))
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
            }
            .foregroundStyle(textColour)
            .frame(maxWidth: .infinity, minHeight: 35)
        }
        .tint(tint)
        .buttonStyle(.borderedProminent)
        .clipShape(.rect(cornerRadius: Constants.CornerRadius.small.rawValue))
    }
}

#Preview {
    AuthenticationButtonView(text: "Login With Apple",
                             image: Image(systemName: "apple.logo"))
}
