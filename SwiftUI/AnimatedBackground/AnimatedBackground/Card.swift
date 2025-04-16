//
//  Card.swift
//  AnimatedBackground
//
//  Created by Rishik Dev on 17/07/23.
//

import SwiftUI

struct Card: View {
    @State private var isAnimating: Bool = false
    
    var fruitName: String
    
    var body: some View {
        Image(fruitName)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(2)
            .background(.white.opacity(0.25))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(2)
            .overlay {
                VStack {
                    Spacer()
                    CardCaption(fruitName: fruitName)
                }
            }
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card(fruitName: "Apples")
    }
}
