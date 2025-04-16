//
//  ZerothTabView.swift
//  MyNotes+
//
//  Created by Rishik Dev on 25/07/22.
//

import SwiftUI

struct ZerothTabView: View
{
    @Binding var currentTab: Int
    @State private var hasAppeared: Bool = false
    
    var body: some View
    {
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [.black, .black, Color("NoteCardYellowColour")]),
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
            
            VStack
            {
                Spacer()
            
                VStack
                {
                    Text("Welcome to")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    
                    Text("My Notes Plus!")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.black)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("NoteCardYellowColour"), Color("NoteCardGreenColour"), Color("NoteCardPinkColour")]),
                                                        startPoint: .leading,
                                                        endPoint: hasAppeared ? .trailing : .leading))
                        .animation(.easeInOut(duration: 2.5), value: hasAppeared)
                        .opacity(hasAppeared ? 1 : 0)
                    
                    Image("Icon")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(15)
                        .shadow(color: .teal, radius: 10)
                        .opacity(hasAppeared ? 1 : 0)
                }
                
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
                    .background(Color("NoteCardYellowColour"))
                    .foregroundColor(.black)
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

struct ZerothTabView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ZerothTabView(currentTab: .constant(0))
    }
}
