//
//  InputFieldView.swift
//  Pickleball
//
//  Created by Rishik Dev on 06/11/24.
//

import SwiftUI

enum InputFieldType {
    case secure
    case regular
}

struct InputFieldView<Header: View, Footer: View>: View {
    @Binding var text: String
    @Binding var inputFieldType: InputFieldType
    
    var placeholder: LocalizedStringResource = ""
    var header: Header?
    var footer: Footer?
    var keyboardType: UIKeyboardType = .default
    var showEye: Bool = false
    
    @State private var showSecureContentFieldContent: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.small.rawValue) {
            HStack {
                if let header {
                    header
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                if(showEye) {
                    Button {
                        withAnimation {
                            showSecureContentFieldContent.toggle()
                            inputFieldType = inputFieldType == .secure ? .regular : .secure
                        }
                    } label: {
                        Image(systemName: showSecureContentFieldContent ? "eye.slash.fill" : "eye.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                    }
                    .tint(.gray)
                    
                }
            }
            
            switch inputFieldType {
            case .secure:
                SecureField(placeholder.key, text: $text)
                    .textFieldStyle(.roundedBorder)
            case .regular:
                TextField(placeholder.key, text: $text)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(keyboardType)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            
            if let footer {
                footer
                    .font(.caption)
            }
        }
    }
}

#Preview {
    InputFieldView(text: .constant(""),
                   inputFieldType: .constant(.regular),
                   placeholder: "Placeholder",
                   header: Text("Header"),
                   footer: Text("Footer"),
                   showEye: true)
}
