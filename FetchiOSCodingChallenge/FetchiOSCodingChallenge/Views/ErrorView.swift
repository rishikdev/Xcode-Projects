//
//  ErrorView.swift
//  FetchiOSCodingChallenge
//
//  Created by Rishik Dev on 26/04/23.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
         
            // Consider putting strings in a separate String file for better
            // programming standards and also to help in localisation.
            Text("Something went wrong. Please try again later.")
                .font(.title)
                .foregroundColor(.gray)
                .fontWeight(.black)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
