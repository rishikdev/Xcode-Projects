//
//  InputFieldView.swift
//  MealRater
//
//  Created by Rishik Dev on 28/10/24.
//

import SwiftUI

struct InputFieldView: View {
    var textValue1: String = ""
    @Binding var textFieldValue1: String
    var textValue2: String = ""
    @Binding var textFieldValue2: String
    
    var body: some View {
        Grid(alignment: .trailing, verticalSpacing: 25) {
            GridRow {
                Text(textValue1)
                TextField(textValue1, text: $textFieldValue1)
                    .textFieldStyle(.roundedBorder)
            }
            
            GridRow {
                Text(textValue2)
                TextField(textValue2, text: $textFieldValue2)
                    .textFieldStyle(.roundedBorder)
            }
        }
        .padding()
    }
}

#Preview {
    InputFieldView(textValue1: "Restaurant",
                   textFieldValue1: .constant(""),
                   textValue2: "Dish",
                   textFieldValue2: .constant(""))
}
