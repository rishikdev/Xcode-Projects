//
//  My_NotesApp.swift
//  My Notes
//
//  Created by Rishik Dev on 18/02/22.
//

import LocalAuthentication
import SwiftUI

@main
struct My_NotesApp: App
{
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    
    @StateObject var myNotesViewModel = MyNotesViewModel()
    @StateObject var quickSettings = QuickSettingsClass()
    @StateObject var checkAppVersion = CheckApplicationVersion()
    
    @State var showAlert: Bool = false
    @State var opacity: CGFloat = 0
    
    var body: some Scene
    {
        WindowGroup
        {
            if(checkAppVersion.currentApplicationVersion != checkAppVersion.savedAppVersion || myNotesViewModel.firstLaunch)
            {
                FirstLaunchView(myNotesViewModel: myNotesViewModel, checkAppVersion: checkAppVersion)
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
                            MyNotesView(myNotesViewModel: myNotesViewModel,quickSettings: quickSettings)
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
                        VStack
                        {
                            Spacer()
                            
                            Button("Unlock My Notes")
                            {
                                myNotesViewModel.authenticate()
                            }
                            
                            Spacer()
                            
                            Button(action: { showAlert = true })
                            {
                                Image(systemName: "info.circle")
                            }
                            .alert("If you are unable to unlock My Notes, please make sure that Touch ID or Face ID is enabled in your device's Settings app.", isPresented: $showAlert)
                            {
                                Button("OK", role: .cancel, action: { })
                            }
                            .padding()
                            
                        }
                        .font(.title2)
                        .buttonStyle(.plain)
                        .foregroundColor(.accentColor)
                    }
                }
                
                else
                {
                    MyNotesView(myNotesViewModel: myNotesViewModel,quickSettings: quickSettings)
                        .transition(.scale)
                }
            }
        }
    }
}
