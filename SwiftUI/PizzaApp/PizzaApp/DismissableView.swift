//
//  DismissableView.swift
//  PizzaApp
//
//  Created by Rishik Dev on 02/05/23.
//

import SwiftUI

struct DismissableView: View {
    @State var data: Data
    
    var body: some View {
        if(data.isHidden) {
            EmptyView()
        } else {
            ZStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text(data.titleText)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(data.bodyText)
                    
                    Image(data.imageName)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                    
                    NavigationLink(destination: Text(data.bodyText)) {
                        Text(data.buttonText)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.indigo)
                    }
                }
                .padding()
                
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                data.isHidden = true
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            .frame(maxWidth: .infinity, minHeight: 400)
            .background(.thinMaterial)
            .cornerRadius(10)
            .transition(.scale)
            .shadow(radius: 2, x: 2, y: 2)
            .padding(5)
        }
    }
}

struct DismissableView_Previews: PreviewProvider {
    static var previews: some View {
        DismissableView(data: Data(id: UUID(),
                                   titleText: "Let's activate your new equipment",
                                   bodyText: "When you're ready, we'll guide you through the activation step by step.",
                                   imageName: "Wifi-Equipment",
                                   buttonText: "Get Started",
                                   isHidden: false))
    }
}
