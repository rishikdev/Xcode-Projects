//
//  PlayControlsView.swift
//  AnimationTest
//
//  Created by Rishik Dev on 16/07/24.
//

import SwiftUI

struct PlayControlsView: View {
    @Binding var shuffleClicked: Bool
    @State var buttons: [AnyView]
    
    var body: some View {
        VStack(spacing: 25) {
            HStack(spacing: 50) {
                buttons[0]
                buttons[1]
                buttons[2]
            }
            
            HStack(spacing: 50) {
                buttons[3]
                buttons[4]
            }
        }
        .font(.title)
        .buttonStyle(BorderlessButtonStyle())
        .onChange(of: shuffleClicked) {
            withAnimation {
                buttons.shuffle()
            }
        }
    }
}

#Preview {
    PlayControlsView(shuffleClicked: .constant(false), buttons: [AnyView(Text("1")), AnyView(Text("2")), AnyView(Text("3")), AnyView(Text("4")), AnyView(Text("5"))])
}
