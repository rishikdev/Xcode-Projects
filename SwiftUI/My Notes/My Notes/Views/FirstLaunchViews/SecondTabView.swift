//
//  SecondTabView.swift
//  My Notes
//
//  Created by Rishik Dev on 22/12/22.
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
            LinearGradient(gradient: Gradient(colors: [Color("AppIconColour"), .red]),
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
                Text("Organise your notes like never before!")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Spacer()
                
                VStack(spacing: 20)
                {
                    if(hasAppeared)
                    {
                        HStack
                        {
                            Image(systemName: "circle.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                            
                            Spacer()

                            Text("Tag your notes with coloured dots to organise them efficiently")
                            
                            Spacer()
                        }
                        .padding()
                        .background(.orange)
                        .cornerRadius(22)
                        .shadow(radius: 5)
                        .transition(.move(edge: .top))

                        HStack
                        {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                            
                            Spacer()

                            Text("Filter your notes with the help of tags for quicker access")
                            
                            Spacer()
                        }
                        .padding()
                        .background(.yellow)
                        .cornerRadius(22)
                        .shadow(radius: 5)
                        .transition(.move(edge: .top))

                        HStack
                        {
                            Image(systemName: "arrow.up.arrow.down.circle")
                                .font(.title2)
                                .foregroundColor(.white)
                            
                            Spacer()

                            Text("Sort your notes either by date or by title to find them easily")
                            
                            Spacer()
                        }
                        .padding()
                        .background(.teal)
                        .cornerRadius(22)
                        .shadow(radius: 5)
                        .transition(.move(edge: .bottom))
                        
                        HStack
                        {
                            Image(systemName: "pin.circle")
                                .font(.title2)
                                .foregroundColor(.black)
                            
                            Spacer()

                            Text("Pin your most important notes to the top to access them quickly")
                            
                            Spacer()
                        }
                        .padding()
                        .background(.gray)
                        .cornerRadius(22)
                        .shadow(radius: 5)
                        .transition(.move(edge: .bottom))
                    }
                }
                .foregroundColor(.black)
                .font(.system(.body, design: .rounded))
                .opacity(hasAppeared ? 1 : 0)
                
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
                    .background(Color("AppIconColour"))
                    .foregroundColor(.white)
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
                    .background(.red)
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

struct SecondTabView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SecondTabView(currentTab: .constant(2))
    }
}
