//
//  CardCaption.swift
//  AnimatedBackground
//
//  Created by Rishik Dev on 17/07/23.
//

import SwiftUI

struct CardCaption: View {
    @State private var isTapped: Bool = false
    @State private var isAnimating: Bool = false
    
    var fruitName: String
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(.clear)
                .background(.ultraThinMaterial)
                .frame(maxWidth: isTapped ? .infinity : 50, maxHeight: 50)
                .overlay {
                    caption
                }
                .background {
                    Shine(duration: 3, distanceFromScreenEdges: 4)
                }
                .cornerRadius(10)
                .padding(2)
            
            if(!isTapped) {
                Spacer()
            }
        }
        .padding(5)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                isTapped.toggle()
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    var caption: some View {
        VStack {
            if(isTapped) {
                ZStack {
                    Text(fruitName)
                    HStack {
                        Image(systemName: "chevron.left.circle")
                            .padding(.horizontal)
                        Spacer()
                    }
                    .opacity(isTapped ? 1 : 0)
                }
            } else {
                Image(systemName: "info.circle")
                    .opacity(isTapped ? 0 : 1)
            }
        }
        .font(.headline)
    }
}

struct CardCaption_Previews: PreviewProvider {
    static var previews: some View {
        CardCaption(fruitName: "Apples")
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
