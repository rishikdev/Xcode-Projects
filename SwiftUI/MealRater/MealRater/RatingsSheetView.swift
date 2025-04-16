//
//  RatingsView.swift
//  MealRater
//
//  Created by Rishik Dev on 28/10/24.
//

import SwiftUI

struct RatingsSheetView: View {
    @Binding var showRatingsSheetView: Bool
    @Binding var isRatingProvided: Bool
    @Binding var rating: Int
    
    @State private var previousRating: Int = 3
        
    var body: some View {
        VStack(spacing: 25) {
            Picker("Rating", selection: $rating) {
                ForEach(1..<6) {
                    Text("\($0)").tag($0)
                }
            }
            .pickerStyle(.segmented)
            
            HStack {
                Button("Cancel", role: .destructive) {
                    rating = previousRating
                    showRatingsSheetView = false
                }
                .tint(.red)
                
                Spacer()
                
                Button("Save") {
                    isRatingProvided = true
                    showRatingsSheetView = false
                }
                .tint(.blue)
            }
            .buttonStyle(.bordered)
            
            Spacer()
        }
        .padding()
        .onAppear {
            previousRating = rating
        }
    }
}

#Preview {
    RatingsSheetView(showRatingsSheetView: .constant(true),
                     isRatingProvided: .constant(false),
                     rating: .constant(3))
}
