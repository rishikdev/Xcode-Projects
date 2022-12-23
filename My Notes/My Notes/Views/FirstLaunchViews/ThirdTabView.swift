//
//  ThirdTabView.swift
//  My Notes
//
//  Created by Rishik Dev on 22/12/22.
//

import SwiftUI
import LocalAuthentication

struct ThirdTabView: View
{
    @Environment(\.dismiss) var dismiss
    @Binding var currentTab: Int
    @StateObject var myNotesViewModel: MyNotesViewModel
    @StateObject var checkAppVersion: CheckApplicationVersion
    
    @State private var hasAppeared: Bool = false
    @State private var shadowRadius: CGFloat = 5
    
    var body: some View
    {
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [.red, .black]),
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
                Text("Your notes are shielded\t\(Image(systemName: "lock.shield.fill"))")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .transition(.slide)
                
                Spacer()
                
                if(hasAppeared)
                {
                    Image(systemName: "touchid")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .cornerRadius(22)
                        .shadow(color: .black, radius: hasAppeared ? 50 : 0)
                        .rotationEffect(.degrees(30))
                        .transition(.move(edge: .leading))
                        .opacity(hasAppeared ? 1 : 0)
                        .padding(.leading, 175)
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    HStack
                    {
                        Image(systemName: "lock.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text("Lock your notes using Biometric Authentication so that only you have access to your notes")
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding()
                    .background(.orange)
                    .cornerRadius(22)
                    .shadow(radius: 5)
                    .transition(.move(edge: .top))
                    
                    Spacer()
                    
                    Image(systemName: "faceid")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .cornerRadius(22)
                        .shadow(color: .black, radius: hasAppeared ? 50 : 0)
                        .rotationEffect(.degrees(-30))
                        .transition(.move(edge: .trailing))
                        .opacity(hasAppeared ? 1 : 0)
                        .padding(.trailing, 175)
                        .foregroundColor(.green)
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
                .background(.red)
                .foregroundColor(.black)
                .cornerRadius(10)
                .shadow(color: .red, radius: shadowRadius)
                .onTapGesture
                {
                    withAnimation
                    {
                        shadowRadius = 1
                        myNotesViewModel.firstLaunch = false
                        checkAppVersion.savedAppVersion = checkAppVersion.currentApplicationVersion
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
        ThirdTabView(currentTab: .constant(3), myNotesViewModel: MyNotesViewModel(), checkAppVersion: CheckApplicationVersion())
    }
}
