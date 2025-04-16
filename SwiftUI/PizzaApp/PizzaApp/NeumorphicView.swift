//
//  NeumorphicView.swift
//  PizzaApp
//
//  Created by Rishik Dev on 12/05/23.
//

import SwiftUI

struct NeumorphicView: View {
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    CustomCircleView(systemImageName: "arrow.left", width: 40)
                    Spacer()
                    Text("Track Name")
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .foregroundColor(.gray)
                    Spacer()
                    CustomCircleView(systemImageName: "line.3.horizontal", width: 40)
                }
                
                Spacer()
                
                CustomCircleView(systemImageName: "music.note", width: 100)
            }
            .padding()
        }
    }
}

private struct CustomCircleView: View {
    var systemImageName: String
    var width: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: width)
                .foregroundColor(.white)
                .shadow(radius: 5, x: 5, y: 5)
                .shadow(color: .white, radius: 5, x: -5, y: -5)
            
            Button { } label: {
                Image(systemName: systemImageName)
                    .padding()
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)
                    
            }
            .overlay {
                Circle()
                    .strokeBorder(Color(uiColor: UIColor.systemGray5), lineWidth: 5)
            }
        }
    }
}

struct NeumorphicView_Previews: PreviewProvider {
    static var previews: some View {
        NeumorphicView()
    }
}
