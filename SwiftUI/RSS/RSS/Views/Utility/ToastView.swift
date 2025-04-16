//
//  ToastView.swift
//  RSS
//
//  Created by Rishik Dev on 11/03/2025.
//

import SwiftUI

struct ToastView: View {
    let text: String
    
    var body: some View {
        TabView {
            Text("\(text) 1")
                .tabItem {
                    Image(systemName: "plus")
                    Text("Add")
                }
            
            Text("\(text) 2")
                .tabItem {
                    Image(systemName: "minus")
                    Text("Subtract")
                }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    ToastView(text: "Some random text")
}
