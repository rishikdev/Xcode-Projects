//
//  ClubsView.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import SwiftUI

struct ClubsView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Clubs")
            }
            .navigationTitle(Constants.ViewTitle.clubs.rawValue.key)
        }
    }
}

#Preview {
    NavigationStack {
        ClubsView()
    }
}
