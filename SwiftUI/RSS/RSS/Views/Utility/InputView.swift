//
//  InputView.swift
//  RSS
//
//  Created by Rishik Dev on 12/02/2025.
//

import SwiftUI

struct InputView<Header: View, Footer: View>: View {
    var header: Header?
    var footer: Footer?
    var keyboardType: UIKeyboardType = .default
    var autocapitalisation: TextInputAutocapitalization = .words
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let header {
                header
                    .font(.callout.smallCaps())
                    .fontWeight(.semibold)
            }
            
            if let footer {
                footer
                    .keyboardType(keyboardType)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(autocapitalisation)
            }
        }
    }
}

#Preview {
    InputView(header: Text("Header"),
              footer: Text("Footer")
    )
}
