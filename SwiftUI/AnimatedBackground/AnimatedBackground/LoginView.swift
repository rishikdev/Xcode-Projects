//
//  PreferredColourSchemeToast.swift
//  AnimatedBackground
//
//  Created by Rishik Dev on 18/07/23.
//

import SwiftUI

struct LoginView: View {
    @State private var showLogin: Bool = false
    @State private var isAnimatingLoginText: Bool = false
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(colors: [.black, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                if(showLogin) {
                    GeometryReader { geo in
                        withAnimation {
                            VStack {
                                Image(systemName: "chevron.up")
                                Text("swipe up to login")
                            }
                            .foregroundColor(.white)
                            .font(.headline)
                            .fontWeight(.bold)
                            .animation(.linear.repeatForever(), value: isAnimatingLoginText)
                            .transition(.opacity)
                            .position(x: geo.frame(in: .local).width / 2,
                                      y: isAnimatingLoginText ? geo.frame(in: .local).height / 4 : geo.frame(in: .local).height / 2)
                        }
                    }
                }
                
                TextField("username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                SecureField("password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                if(showLogin) {
                    Spacer(minLength: 20)
                }
            }
            .onChange(of: username + password) { _ in
                withAnimation {
                    showLogin = !username.trimmingCharacters(in: .whitespaces).isEmpty && !password.trimmingCharacters(in: .whitespaces).isEmpty
                    isAnimatingLoginText = showLogin
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 4)
            .background(.ultraThinMaterial)
        }
        .preferredColorScheme(.light)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
                .previewDisplayName("Light")
                .preferredColorScheme(.light)
            
            LoginView()
                .previewDisplayName("Dark")
                .preferredColorScheme(.dark)
        }
    }
}
