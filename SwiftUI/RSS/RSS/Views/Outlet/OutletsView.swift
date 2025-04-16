//
//  OutletsView.swift
//  RSS
//
//  Created by Rishik Dev on 15/01/2025.
//

import SwiftUI

struct OutletsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var outletViewModel: OutletViewModel
    @State private var path: [OutletModel] = []
    @State private var isNewOutlet: Bool = false
    @State private var showAlert: Bool = false
    
    // MARK: - body
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                switch outletViewModel.outletCoreDataTransactionStatus {
                case .uninitiated, .loading:
                    LoadingView(primaryText: "Loading", secondaryText: "Outlets")
                case .success:
                    loadedOutletsView
                case .failure:
                    InformationView(primaryText: "Something went wrong",
                                    secondaryText: outletViewModel.errorMessage,
                                    primaryTextForegroundColor: .red)
                }
            }
            .interactiveDismissDisabled()
            // MARK: - onAppear
            .onAppear {
                self.isNewOutlet = false
                deleteInvalidOutlets()
                outletViewModel.fetchOutlets()
            }
            // MARK: - toolbar
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    dismissButtonView
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    addOutletButtonView
                }
                
                ToolbarItem(placement: .bottomBar) {
                    outletsCountView
                }
            }
            // MARK: - navigationDestination
            .navigationDestination(for: OutletModel.self) { outlet in
                OutletDetailsView(outlet: outlet, showDeleteActions: !isNewOutlet)
            }
            .navigationTitle("Outlets")
        }
    }
    
    // MARK: - loadedOutletsView
    private var loadedOutletsView: some View {
        VStack {
            if outletViewModel.outlets.isEmpty {
                InformationView(primaryText: "No outlets")
            } else {
                List {
                    ForEach(outletViewModel.outlets, id: \.id) { outlet in
                        ZStack {
                            NavigationLink(value: outlet) {
                                EmptyView()
                            }
                            .opacity(0)
                            
                            OutletCellView(outlet: outlet)
                                .lineLimit(1)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            deleteOutlet(outlet)
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                    .id(UUID())
                }
            }
        }
        .listStyle(.plain)
    }
    
    // MARK: - addOutletButtonView
    private var addOutletButtonView: some View {
        CircularButtonView(text: "Add Outlet", systemImage: "plus") {
            self.isNewOutlet = true
            addOutlet()
        }
    }
    
    // MARK: - dismissButtonView
    private var dismissButtonView: some View {
        CircularButtonView(text: "Dismiss", systemImage: "xmark", tint: .red) {
            dismiss()
        }
    }
    
    // MARK: - OutletsCountView
    private var outletsCountView: some View {
        Text("^[\(outletViewModel.outlets.count) Outlets](inflect: true)")
            .font(.caption2)
            .foregroundColor(.secondary)
    }
    
    // MARK: - addOutlet()
    private func addOutlet() {
        let outlet = OutletModel(id: UUID(), name: "", rssUrl: "", tag: "red", feedItemsCount: 0)
        outletViewModel.addOutlet(outlet)
        path.append(outlet)
    }
    
    // MARK: - updateOutlet()
    private func updateOutlet(_ outlet: OutletModel) {
        outletViewModel.updateOutlet(outlet)
    }
    
    // MARK: - deleteInvalidOutlets()
    private func deleteInvalidOutlets() {
        for outlet in outletViewModel.outlets {
            if (outlet.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                outlet.rssUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
                withAnimation {
                    deleteOutlet(outlet)
                }
            }
        }
    }
    
    // MARK: - deleteOutlet(id:)
    private func deleteOutlet(_ outlet: OutletModel) {
        outletViewModel.deleteOutlet(outlet)
    }
}

#Preview {
    OutletsView()
        .environmentObject(FeedViewModel(coreDataManager: CoreDataManager.shared,
                                         feedParser: FeedParser.shared,
                                         networkManager: NetworkManager.shared))
        .environmentObject(OutletViewModel(coreDataManager: CoreDataManager.shared))
}
