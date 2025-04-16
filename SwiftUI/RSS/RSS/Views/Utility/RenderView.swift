//
//  RenderView.swift
//  RSS
//
//  Created by Rishik Dev on 14/03/2025.
//

import SwiftUI

struct RenderView: View {
    let text: String
    let tag: String
    
    var body: some View {
        Text(text.prefix(3))
            .font(.custom("AmericanTypewriter-Bold", size: 12))
            .frame(width: 44, height: 44)
            .foregroundStyle(tag.toColour())
            .brightness(0.7)
            .background(tag.toColour())
            .clipShape(.rect(cornerRadius: 10))
    }
}
