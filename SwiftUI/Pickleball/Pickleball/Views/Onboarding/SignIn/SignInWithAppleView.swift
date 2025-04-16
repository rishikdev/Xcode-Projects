//
//  SignInWithAppleView.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleView: View {
    @Environment(\.colorScheme) private var colourScheme
    @ObservedObject var signInViewModel: SignInViewModel
    
    @Binding var disableInteraction: Bool
    
    var body: some View {
        VStack {
            SignInWithAppleButton() { request in
                signInViewModel.signInWithAppleHandleRequest(request)
            } onCompletion: { result in
                signInViewModel.signInWithAppleHandleCompletion(result)
            }
            .id(colourScheme == .light ? "light": "dark")   // .id(_:) is required to force SignInWithAppleButton() to update its style
            .signInWithAppleButtonStyle(colourScheme == .light ? .black : .whiteOutline)
            .frame(maxWidth: .infinity, minHeight: 50)
            .clipShape(.rect(cornerRadius: Constants.CornerRadius.small.rawValue))
            .disabled(disableInteraction)
            .opacity(disableInteraction ? (colourScheme == .light ? 0.06 : 0.15) : 1)
        }
    }
}

#Preview {
    SignInWithAppleView(signInViewModel: .init(firebaseUserAuthentication: FirebaseUserAuthenticationManager.shared),
                        disableInteraction: .constant(false))
}
