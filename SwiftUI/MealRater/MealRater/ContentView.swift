//
//  ContentView.swift
//  MealRater
//
//  Created by Rishik Dev on 28/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
                .navigationTitle("Meal Rater")
        }
    }
}

#Preview {
    ContentView()
}
