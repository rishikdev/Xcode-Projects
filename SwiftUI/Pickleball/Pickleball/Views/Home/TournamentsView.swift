//
//  TournamentsView.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import SwiftUI

struct TournamentsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Tournaments")
            }
            .navigationTitle(Constants.ViewTitle.tournaments.rawValue.key)
        }
    }
}

#Preview {
    NavigationStack {
        TournamentsView()
    }
}
