//
//  CassetteView.swift
//  AnimationTest
//
//  Created by Rishik Dev on 16/07/24.
//

import SwiftUI

struct CassetteView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(1...10, id: \.self) {
                    Text("Item \($0)")
                        .frame(minWidth: 250, minHeight: 125)
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .shadow(radius: 10)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    CassetteView()
}
