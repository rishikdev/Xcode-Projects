//
//  FirstPage.swift
//  My Notes
//
//  Created by Rishik Dev on 22/12/22.
//

import SwiftUI

struct FirstTabView: View
{
    @Binding var currentTab: Int
    @State private var hasAppeared: Bool = false
    
    var body: some View
    {
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [.black, .black, Color("AppIconColour")]),
                           startPoint: hasAppeared ? .topLeading : .bottomTrailing,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .onAppear
                {
                    withAnimation(.easeInOut(duration: 2.5))
                    {
                        hasAppeared = true
                    }
                }
                .onDisappear()
                {
                    hasAppeared = false
                }
            
            VStack()
            {
                Spacer()
            
                Text("Welcome to My Notes!")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(Color("AppIconColour"))
                    .animation(.easeInOut(duration: 2.5), value: hasAppeared)
                    .opacity(hasAppeared ? 1 : 0)
                
                Image("Icon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(15)
                    .shadow(color: .teal, radius: 10)
                    .opacity(hasAppeared ? 1 : 0)
                
                Spacer()
                
                HStack
                {
                    Spacer()
                    
                    Button(action: {
                        withAnimation
                        {
                            currentTab = currentTab + 1
                        }
                    })
                    {
                        Image(systemName: "arrow.right")
                    }
                    .buttonStyle(.plain)
                    .padding(10)
                    .background(Color("AppIconColour"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .opacity(hasAppeared ? 1 : 0)
                    .padding(.trailing)
                }
            }
            .padding()
        }
    }
}

struct FirstPage_Previews: PreviewProvider
{
    static var previews: some View
    {
        FirstTabView(currentTab: .constant(1))
    }
}
