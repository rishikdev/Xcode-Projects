//
//  BottomBarView.swift
//  RSS
//
//  Created by Rishik Dev on 06/03/2025.
//

import SwiftUI

struct BottomBarView: View {
    @EnvironmentObject private var feedViewModel: FeedViewModel
    @EnvironmentObject private var outletViewModel: OutletViewModel
    @Binding var showErrorsListSheet: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            LastFetchedTextView()
            
            if (!feedViewModel.failedOperations.isEmpty ||
                !outletViewModel.errorMessage.isEmpty) {
                SeeErrorsButtonView(showErrorsListSheet: $showErrorsListSheet)
            }
        }
    }
}

#Preview {
    BottomBarView(showErrorsListSheet: .constant(true))
        .environmentObject(FeedViewModel(coreDataManager: CoreDataManager.shared,
                                         feedParser: FeedParser.shared,
                                         networkManager: NetworkManager.shared))
        .environmentObject(OutletViewModel(coreDataManager: CoreDataManager.shared))
}
