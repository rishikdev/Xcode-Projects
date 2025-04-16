//
//  SignInWithGoogleView.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import SwiftUI

struct SignInWithGoogleView: View {
    @Environment(\.colorScheme) private var colourScheme
    @ObservedObject var signInViewModel: SignInViewModel
    
    var body: some View {
        VStack {
            AuthenticationButtonView(text: Constants.ButtonText.signInWithGoogle.rawValue,
                                     image: Image("google.logo"),
                                     textColour: colourScheme == .light ? .white : .black,
                                     tint: colourScheme == .light ? .black : .white) {
                Task {
                    await signInViewModel.signInWithGoogle()
                }
            }
        }
    }
}

#Preview {
    SignInWithGoogleView(signInViewModel: .init(firebaseUserAuthentication: FirebaseUserAuthenticationManager.shared))
}
