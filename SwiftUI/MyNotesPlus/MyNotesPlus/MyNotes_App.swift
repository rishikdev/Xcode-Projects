//
//  MyNotes_App.swift
//  MyNotes+
//
//  Created by Rishik Dev on 11/06/22.
//

#if !os(watchOS)
import LocalAuthentication
#endif
import SwiftUI

@main
struct MyNotesApp: App
{
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var myNotesViewModel = MyNotesViewModel()
    @StateObject var quickSettings = QuickSettingsClass()
    
    @State var showAlert: Bool = false
    @State var opacity: CGFloat = 0
    
    var body: some Scene
    {
        WindowGroup
        {
            if(myNotesViewModel.firstLaunch)
            {
                #if !os(watchOS)
                FirstLaunchView(myNotesViewModel: myNotesViewModel)
                
                #else
                HomeView(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
                
                #endif
            }
            
            else
            {
                // If the user has toggled Biometric authentication on, then check for authentication, otherwise skip the authentication part.
                if(quickSettings.isUsingBiometric)
                {
                    if(myNotesViewModel.isAuthenticated)
                    {
                        ZStack
                        {
                            HomeView(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
                                .overlay
                                {
                                    Rectangle()
                                        .opacity(opacity)
                                        .ignoresSafeArea()
                                        .animation(.easeInOut, value: opacity)
                                        .transition(.scale)
                                }
                                .onChange(of: scenePhase)
                                {
                                    newPhase in
                                    
                                    if(newPhase == .active)
                                    {
                                        opacity = 0
                                    }
                                    
                                    else if(newPhase == .inactive)
                                    {
                                        opacity = 1
                                    }
                                    
                                    else if(newPhase == .background)
                                    {
                                        opacity = 1
                                        myNotesViewModel.isAuthenticated = false
                                    }
                                }
                            
                            if(opacity > 0)
                            {
                                withAnimation
                                {
                                    Image(systemName: "lock.shield.fill")
                                        .font(.largeTitle)
                                        .animation(.easeInOut, value: opacity)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    
                    else
                    {
                        UnlockMyNotesPlus
                    }
                }
                
                else
                {
                    HomeView(myNotesViewModel: myNotesViewModel, quickSettings: quickSettings)
                        .transition(.scale)
                }
            }
        }
    }
    
    var UnlockMyNotesPlus: some View
    {
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [Color("NoteCardYellowColour"), Color("NoteCardGreenColour"), Color("NoteCardPinkColour")]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack
            {
                Spacer()
                
                Image("Icon")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding()
                                            
                Button("Unlock My Notes +")
                {
                    #if !os(watchOS)
                    myNotesViewModel.authenticate()
                    #endif
                }
                .foregroundColor(.white)
                .padding(10)
                .background(.teal)
                .cornerRadius(15)
                .shadow(radius: 5)
                
                Spacer()
                
                Button(action: { showAlert = true })
                {
                    Image(systemName: "info.circle")
                }
                .alert("Unable to unlock My Notes +?", isPresented: $showAlert)
                {
                    Button("OK", role: .cancel, action: { })
                } message: {
                    Text("If you are unable to unlock My Notes, please make sure that Touch ID or Face ID is enabled in your device's Settings app.")
                }
                .foregroundColor(.white)
                .padding()
                .background(.teal)
                .cornerRadius(50)
                .shadow(radius: 5)
                .padding()
                
            }
            .font(.title2)
            .buttonStyle(.plain)
            .foregroundColor(.accentColor)
        }
    }
}

