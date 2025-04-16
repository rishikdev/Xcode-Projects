//
//  CardCountButton.swift
//  AnimatedBackground
//
//  Created by Rishik Dev on 17/07/23.
//

import SwiftUI

struct CustomButton: View {
    @Environment(\.colorScheme) private var colourScheme
    
    var buttonLabel: Image
    var buttonAction: () -> Void
    var lightModeTint: Color? = .black
    var darkModeTint: Color? = Color(uiColor: .systemGray6)

    var body: some View {
        Button {
            withAnimation {
                buttonAction()
            }
        } label: {
            buttonLabel
                .frame(height: 20)
        }
        .clipShape(Circle())
        .buttonStyle(.bordered)
        .tint(colourScheme == .light ? lightModeTint : darkModeTint)
        .foregroundColor(colourScheme == .light ? .black : .white)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(buttonLabel: Image(systemName: "plus"), buttonAction: { })
    }
}
