//
//  FirstTab.swift
//  MyNotes+
//
//  Created by Rishik Dev on 25/07/22.
//

import SwiftUI

struct FirstTabVIew: View
{
    @Binding var currentTab: Int
    @State private var hasAppeared: Bool = false
    
    var body: some View
    {
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [Color("NoteCardYellowColour"), Color("NoteCardGreenColour")]),
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
                    .foregroundColor(.black)
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

                            Text("Tags help you organise your notes efficiently")
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color("NoteCardYellowColour"))
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
                        .background(Color("NoteCardGreenColour"))
                        .cornerRadius(22)
                        .shadow(radius: 5)
                        .transition(.move(edge: .top))

                        HStack
                        {
                            Image(systemName: "lock.fill")
                                .font(.title2)
                                .foregroundColor(.black)
                            
                            Spacer()

                            Text("Use biometric authentication to keep your notes secure")
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color("NoteCardPinkColour"))
                        .cornerRadius(22)
                        .shadow(radius: 5)
                        .transition(.move(edge: .bottom))

                        HStack
                        {
                            Image(systemName: "cloud.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                            
                            Spacer()

                            Text("Your notes are synchronised with your iCloud account")
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color("NoteCardYellowColour"))
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
                    .background(Color("NoteCardYellowColour"))
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
                    .background(Color("NoteCardGreenColour"))
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


struct FirstTab_Previews: PreviewProvider
{
    static var previews: some View
    {
        FirstTabVIew(currentTab: .constant(1))
    }
}
