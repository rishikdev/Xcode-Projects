//
//  LoadingView.swift
//  RSS
//
//  Created by Rishik Dev on 25/02/2025.
//

import SwiftUI

struct LoadingView: View {
    let primaryText: String
    let secondaryText: String
    
    var body: some View {
        ZStack(alignment: .top) {
            ProgressView()
            
            VStack {
                Text(primaryText)
                    .fontWeight(.heavy)
                Text(secondaryText)
            }
            .padding(.top, 40)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    LoadingView(primaryText: "Loading",
                secondaryText: "GSMArena")
}
