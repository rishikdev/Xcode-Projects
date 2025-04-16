//
//  ContentView.swift
//  AnimatedBackground
//
//  Created by Rishik Dev on 14/07/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) private var colourScheme
    
    @State private var isAnimating: Bool = false
    @State private var cardCount: Int = 1
    @State private var preferredColourScheme: ColorScheme = .light
    @State private var isPreferredColourSchemeChanged: Bool = false
    
    private let backgroundColoursLight: [Color] = [.blue, .purple, .pink]
    private let backgroundColoursDark: [Color] = [.red, .black, .black]
    private let preferredColourSchemeToastDuration: Double = 3
    
    var body: some View {
        ZStack {
            background
            VStack {
                cardControls
                cards
            }
            .overlay {
                if(isPreferredColourSchemeChanged) {
                    VStack {
                        Spacer()
                        preferredColourSchemeToast
                    }
                    .transition(.opacity)
                }
            }
        }
        .onAppear {
            preferredColourScheme = colourScheme
        }
        .onChange(of: preferredColourScheme, perform: { _ in
            withAnimation(.easeInOut) {
                isPreferredColourSchemeChanged.toggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + preferredColourSchemeToastDuration) {
                withAnimation(.easeInOut) {
                    isPreferredColourSchemeChanged.toggle()
                }
            }
        })
        .preferredColorScheme(preferredColourScheme)
    }
    
    var background: some View {
        LinearGradient(colors: preferredColourScheme == .light ? backgroundColoursLight : backgroundColoursDark,
                       startPoint: isAnimating ? .topLeading : .bottomLeading,
                       endPoint: isAnimating ? .bottomTrailing : .topTrailing)
            .animation(.easeIn(duration: 30).repeatForever(autoreverses: true), value: isAnimating)
            .ignoresSafeArea()
            .onAppear {
                isAnimating = true
            }
    }
    
    var cardControls: some View {
        HStack {
            Text("^[\(cardCount) Fruit](inflect: true)")
                .padding(10)
                .background(.ultraThinMaterial.opacity(0.5))
                .cornerRadius(20)
                .tint(.black)
            
            Spacer()
            
            CustomButton(buttonLabel: Image(systemName: preferredColourScheme == .light ? "moon.fill" : "sun.max.fill"), buttonAction: {
                preferredColourScheme = preferredColourScheme == .light ? .dark : .light
            }, lightModeTint: .white, darkModeTint: .yellow)
            .disabled(isPreferredColourSchemeChanged)

            Spacer()
            
            CustomButton(buttonLabel: Image(systemName: "minus"), buttonAction: {
                cardCount = max(1, cardCount - 1)
            })
            .disabled(cardCount == 1)
            
            Spacer()
            
            CustomButton(buttonLabel: Image(systemName: "plus"), buttonAction: {
                cardCount = min(fruits.count, cardCount + 1)
            })
            .disabled(cardCount == fruits.count)
        }
        .padding(.horizontal)
    }
    
    var cards: some View {
        ScrollView {
            ForEach(0..<cardCount, id: \.self) { cardNumber in
                Card(fruitName: fruits[cardNumber])
            }
        }
    }
    
    var preferredColourSchemeToast: some View {
        Rectangle()
            .foregroundColor(.clear)
            .background(.thinMaterial)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .overlay {
                Text("\(preferredColourScheme == .light ? "Light" : "Dark") mode activated")
            }
            .background {
                Shine(duration: preferredColourSchemeToastDuration)
            }
            .cornerRadius(10)
            .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .previewDisplayName("Light")
//                .preferredColorScheme(.light)
            
            HomeView()
                .previewDisplayName("Dark")
                .preferredColorScheme(.dark)
        }
    }
}
