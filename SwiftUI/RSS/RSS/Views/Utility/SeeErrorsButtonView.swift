//
//  SeeErrorsButtonView.swift
//  RSS
//
//  Created by Rishik Dev on 06/03/2025.
//

import SwiftUI

struct SeeErrorsButtonView: View {
    @EnvironmentObject private var feedViewModel: FeedViewModel
    @EnvironmentObject private var outletViewModel: OutletViewModel
    @Binding var showErrorsListSheet: Bool
    
    var body: some View {
        Button("See ^[\(feedViewModel.failedOperations.count + (outletViewModel.errorMessage.isEmpty ? 0 : 1)) Errors](inflect:true)") {
            self.showErrorsListSheet.toggle()
        }
        .buttonStyle(.plain)
        .font(.caption2)
        .foregroundStyle(.red)
        .sheet(isPresented: $showErrorsListSheet) {
            ErrorsListView()
                .environmentObject(feedViewModel)
        }
    }
}

#Preview {
    SeeErrorsButtonView(showErrorsListSheet: .constant(false))
        .environmentObject(FeedViewModel(coreDataManager: CoreDataManager.shared,
                                         feedParser: FeedParser.shared,
                                         networkManager: NetworkManager.shared))
        .environmentObject(OutletViewModel(coreDataManager: CoreDataManager.shared))
}
