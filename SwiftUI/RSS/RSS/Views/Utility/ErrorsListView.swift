//
//  ErrorsListView.swift
//  RSS
//
//  Created by Rishik Dev on 06/03/2025.
//

import SwiftUI

struct ErrorsListView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var feedViewModel: FeedViewModel
    @EnvironmentObject private var outletViewModel: OutletViewModel
    
    var body: some View {
        NavigationStack {
            List {
                if (!feedViewModel.failedOperations.isEmpty) {
                    Section("Feed Items") {
                        ForEach(feedViewModel.failedOperations, id: \.hashValue) { failedOperation in
                            switch failedOperation {
                            case .fetchLocal(value: let value):
                                Text(value)
                            case .fetchRemote(value: let value):
                                Text(value)
                            case .parse(value: let value):
                                Text(value)
                            case .save(value: let value):
                                Text(value)
                            }
                        }
                    }
                }
                
                if (!outletViewModel.errorMessage.isEmpty) {
                    Section ("Outlets") {
                        Text(outletViewModel.errorMessage)
                    }
                }
            }
            .listStyle(.plain)
            .font(.body)
            .navigationTitle("Errors")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    dismissButtonView
                }
            }
            .interactiveDismissDisabled()
        }
    }
    
    // MARK: - dismissButtonView
    private var dismissButtonView: some View {
        CircularButtonView(text: "Dismiss", systemImage: "xmark", tint: .red) {
            dismiss()
        }
    }
}

#Preview {
    ErrorsListView()
        .environmentObject(FeedViewModel(coreDataManager: CoreDataManager.shared,
                                         feedParser: FeedParser.shared,
                                         networkManager: NetworkManager.shared))
        .environmentObject(OutletViewModel(coreDataManager: CoreDataManager.shared))
}
