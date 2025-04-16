//
//  LastFetchedTextView.swift
//  RSS
//
//  Created by Rishik Dev on 06/03/2025.
//

import SwiftUI

struct LastFetchedTextView: View {
    @AppStorage("lastFetched") private var lastFetched: String = "Never"
    
    var body: some View {
        Text("Last Fetched: \(lastFetched)")
            .foregroundColor(.secondary)
            .font(.caption2)
    }
}

#Preview {
    LastFetchedTextView()
}
