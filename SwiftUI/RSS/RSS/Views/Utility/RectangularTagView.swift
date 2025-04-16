//
//  RectangularTagView.swift
//  RSS
//
//  Created by Rishik Dev on 21/02/2025.
//

import SwiftUI

struct RectangularTagView: View {
    let text: String
    let colour: Color
    var textColour: Color? = nil
    var brightness: Double = 0.7
    var rotationAngle: Double = -90
    
    var body: some View {
        Rectangle()
            .fill(colour)
            .overlay {
                Text(text.prefix(15))
                    .font(.custom("AmericanTypewriter", size: 10))
                    .foregroundStyle(textColour ?? colour)
                    .brightness(brightness)
                    .textCase(.uppercase)
                    .fontWeight(.black)
                    .rotationEffect(.degrees(rotationAngle))
                    .fixedSize()
            }
            .frame(maxWidth: 15, minHeight: 125)
    }
}

#Preview {
    RectangularTagView(text: "Cat Outlet", colour: "brown".toColour())
}
