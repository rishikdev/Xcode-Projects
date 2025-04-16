//
//  ThirdTabView.swift
//  MyNotes+
//
//  Created by Rishik Dev on 25/07/22.
//

import SwiftUI

struct ThirdTabView: View
{
    @Environment(\.dismiss) var dismiss
    @ObservedObject var myNotesViewModel: MyNotesViewModel
    @State private var hasAppeared: Bool = false
    @State private var shadowRadius: CGFloat = 5
    
    var body: some View
    {
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [Color("NoteCardPinkColour"), .black]),
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
                (Text("Synchronise your notes with your ") + Text(Image(systemName: "applelogo")) + Text(" Watch!"))
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .transition(.slide)
                
                Spacer()
                
                if(hasAppeared)
                {
                    Image("FirstLaunchImage_WatchButtons")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 100, minHeight: 155)
                        .cornerRadius(22)
                        .shadow(color: .black, radius: hasAppeared ? 50 : 0)
                        .rotationEffect(.degrees(30))
                        .transition(.move(edge: .leading))
                        .opacity(hasAppeared ? 1 : 0)
                        .padding(.leading, 175)
                    
                    Image("FirstLaunchImage_WatchNotes")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 100, minHeight: 155)
                        .cornerRadius(22)
                        .shadow(color: .black, radius: hasAppeared ? 50 : 0)
                        .rotationEffect(.degrees(-30))
                        .transition(.move(edge: .trailing))
                        .opacity(hasAppeared ? 1 : 0)
                        .padding(.trailing, 175)
                }
                
                Spacer()
                
                Button
                {
                    withAnimation
                    {
                        myNotesViewModel.firstLaunch = false
                        dismiss()
                    }
                } label: {
                    Text("Continue")
                }
                .buttonStyle(.plain)
                .frame(width: 275, height: 40)
                .padding(10)
                .background(Color("NoteCardPinkColour"))
                .foregroundColor(.black)
                .cornerRadius(10)
                .shadow(color: .pink, radius: shadowRadius)
                .onTapGesture
                {
                    withAnimation
                    {
                        shadowRadius = 1
                        myNotesViewModel.firstLaunch = false
                        dismiss()
                    }
                }
            }
            .padding()
        }
    }
}

struct ThirdTabView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ThirdTabView(myNotesViewModel: MyNotesViewModel())
    }
}
