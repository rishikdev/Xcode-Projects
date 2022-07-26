//
//  SwiftUIView.swift
//  MyNotes+
//
//  Created by Rishik Dev on 25/07/22.
//

import SwiftUI

struct SecondTabView: View
{
    @Binding var currentTab: Int
    @State private var hasAppeared: Bool = false
    
    var body: some View
    {
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [Color("NoteCardGreenColour"), Color("NoteCardPinkColour")]),
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
                Text("Use widgets to maximise your productivity!")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                Spacer()
                                
                Image("FirstLaunchImage_SmallWidget")
                    .resizable()
//                    .frame(width: 150, height: 150)
                    .scaledToFit()
                    .frame(maxWidth: 200, maxHeight: 200)
                    .rotation3DEffect(.degrees(hasAppeared ? 0 : -10), axis: (x: -1, y: -2, z: 1))
                    .shadow(radius: 5, x: -2, y: 2)
            
                Image("FirstLaunchImage_MediumWidget")
                    .resizable()
//                    .frame(width: 281.25, height: 150)
                    .scaledToFit()
                    .frame(maxWidth: 367, maxHeight: 200)
                    .rotation3DEffect(.degrees(hasAppeared ? 0 : -10), axis: (x: -1, y: -1, z: 0))
                    .shadow(radius: 5, x: 2, y: 2)
                
                Text("There are more customisable widgets available for you to explore.")
//                    .font(.caption)
                    .padding()
                    .background(Color("NoteCardGreenColour"))
                    .cornerRadius(15)
                    .frame(minWidth: 300, minHeight: 75)
                    .shadow(radius: 5, x: 2, y: -2)
                    .rotation3DEffect(.degrees(hasAppeared ? 10 : 0), axis: (x: -1, y: -1, z: 0))
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.trailing)
                
                Spacer()
                
                HStack
                {
                    Button(action: {
                        withAnimation
                        {
                            currentTab = currentTab - 1
                        }
                    })
                    {
                        Image(systemName: "arrow.left")
                    }
                    .buttonStyle(.plain)
                    .padding(10)
                    .background(Color("NoteCardGreenColour"))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .disabled(currentTab <= 0)
                    .padding(.leading)
                    
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
                    .background(Color("NoteCardPinkColour"))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.trailing)
                }
            }
            .padding()
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SecondTabView(currentTab: .constant(2))
    }
}
