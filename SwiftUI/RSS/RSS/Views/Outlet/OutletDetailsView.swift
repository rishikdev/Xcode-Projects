//
//  OutletDetailsView.swift
//  RSS
//
//  Created by Rishik Dev on 12/02/2025.
//

import SwiftData
import SwiftUI

enum ItemToDelete {
    case feedItems, outlet, none
}

struct OutletDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var outletViewModel: OutletViewModel
    @EnvironmentObject private var feedViewModel: FeedViewModel
    
    @State var outlet: OutletModel
    @State private var disableDeleteButton: Bool = false
    @State private var showAlert: Bool = false
    @State private var showConfirmationDialog: Bool = false
    @State private var itemToDelete: ItemToDelete = .none
    
    var showDeleteActions: Bool = false
    
    private let tags: [Color] = [.red, .green, .blue, .yellow, .purple, .brown]
    private let tagWidth: CGFloat = 75
    
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    // MARK: - body
    var body: some View {
        VStack {
            Form {
                Section {
                    nameInputView
                    urlInputView
                } header: {
                    Text("Details")
                } footer: {
                    Text("Both **Name** and **RSS Feed URL** are required. If either is not provided, the outlet will not be saved.")
                }
                
                Section("Additional Details") {
                    tagInputView
                    enableOutletView
                }
                
                if (showDeleteActions) {
                    Section("Delete Actions") {
                        deleteFeedItemsView
                        deleteOutletView
                    }
                    .disabled(outletViewModel.outletCoreDataTransactionStatus == .loading ||
                              feedViewModel.feedItemCoreDataTransactionStatus == .loading)
                }
            }
        }
        .onChange(of: outlet) { _ in
            updateOutlet()
        }
        .onChange(of: outletViewModel.outletCoreDataTransactionStatus) { status in
            self.showAlert = status == .failure
        }
        .onChange(of: feedViewModel.feedItemCoreDataTransactionStatus) { status in
            self.showAlert = status == .failure
        }
        .confirmationDialog("Are you sure?",
                            isPresented: $showConfirmationDialog,
                            titleVisibility: .visible,
                            actions: {
            Button("Delete", role: .destructive) {
                deleteAction()
            }
        },
                            message: {
            Text("This action cannot be undone.")
        })
        .alert("Oh no!",
               isPresented: $showAlert) {
            Button("Dismiss") { outletViewModel.outletCoreDataTransactionStatus = .uninitiated }
        } message: {
            Text(outletViewModel.errorMessage)
        }
        .navigationTitle("Details")
    }
    
    // MARK: - nameInputView
    private var nameInputView: some View {
        TextField("Name", text: $outlet.name)
    }
    
    // MARK: - urlInputView
    private var urlInputView: some View {
        TextField("RSS Feed URL", text: $outlet.rssUrl)
            .keyboardType(.URL)
            .textInputAutocapitalization(.never)
    }
    
    // MARK: - tagInputView
    private var tagInputView: some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(tags, id: \.self) { tag in
                    Circle()
                        .fill(tag)
                        .overlay {
                            if outlet.tag == tag.description {
                                Image(systemName: "checkmark.circle")
                                    .font(.system(size: tagWidth))
                                    .foregroundStyle(tag)
                                    .brightness(0.5)
                            }
                        }
                        .frame(width: tagWidth)
                        .padding(10)
                        .onTapGesture {
                            withAnimation {
                                outlet.tag = tag.description
                            }
                        }
                }
            }
        }
    }
    
    // MARK: - deleteFeedItemsView
    private var deleteFeedItemsView: some View {
        Button("Delete Feed Items", role: .destructive) {
            self.itemToDelete = .feedItems
            self.showConfirmationDialog.toggle()
        }
        .disabled(outlet.feedItemsCount == 0 || disableDeleteButton)
    }
    
    // MARK: - deleteOutletView
    private var deleteOutletView: some View {
        Button(role: .destructive) {
            self.itemToDelete = .outlet
            self.showConfirmationDialog.toggle()
        } label: {
            Text("Delete \(outlet.name)")
                .lineLimit(1)
        }
    }
    
    // MARK: - enableOutletView
    private var enableOutletView: some View {
        Toggle("Enable Outlet", isOn: $outlet.isEnabled)
    }
    
    // MARK: - updateOutlet
    private func updateOutlet() {
        outletViewModel.updateOutlet(outlet)
    }
    
    // MARK: - deleteAction
    private func deleteAction() {
        switch itemToDelete {
        case .feedItems:
            feedViewModel.deleteFeedItems(for: outlet)
            outletViewModel.fetchOutlets()
            self.disableDeleteButton = true
            itemToDelete = .none
        case .outlet:
            outletViewModel.deleteOutlet(outlet)
            itemToDelete = .none
            dismiss()
        case .none:
            break
        }
    }
}

#Preview {
    NavigationStack {
        OutletDetailsView(outlet: OutletModel(id: UUID(),
                                              name: "Outlet 1",
                                              rssUrl: "www.cats1.com",
                                              tag: "red"),
                          showDeleteActions: true)
        .environmentObject(OutletViewModel(coreDataManager: CoreDataManager.shared))
        .environmentObject(FeedViewModel(coreDataManager: CoreDataManager.shared,
                                         feedParser: FeedParser.shared,
                                         networkManager: NetworkManager.shared))
    }
}
