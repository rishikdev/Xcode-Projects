//
//  OutletCellView.swift
//  RSS
//
//  Created by Rishik Dev on 12/02/2025.
//

import SwiftUI

struct OutletCellView: View {
    @Environment(\.displayScale) private var displayScale
    @EnvironmentObject private var outletViewModel: OutletViewModel
    
    @State private var renderedImage = Image(systemName: "photo")
    @State var outlet: OutletModel
    
    var body: some View {
        HStack {
            renderedImage
                .onAppear {
                    render(text: outlet.name.firstLettersOfEachWord(),
                           tag: outlet.tag)
                }
            
            VStack(alignment: .leading) {
                Text(outlet.name)
                Text(outlet.rssUrl)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(outlet.feedItemsCount.description)
                .font(.callout)
                .padding()
                .frame(height: 44)
                .background(Color(uiColor: .secondarySystemBackground))
                .foregroundStyle(.secondary)
                .clipShape(.rect(cornerRadius: 10))
            
            CircularButtonView(text: outlet.isEnabled ? "Outlet Enabled" : "Outlet Disabled",
                               systemImage: outlet.isEnabled ? "eye.fill" : "eye.slash.fill",
                               tint: outlet.isEnabled ? .green : .red) {
                outlet.isEnabled.toggle()
                updateOutlet()
            }
                               .labelStyle(.iconOnly)
        }
    }
    
    // MARK: - render(text:)
    @MainActor
    private func render(text: String, tag: String) {
        let renderer = ImageRenderer(content: RenderView(text: text, tag: tag))
        
        // make sure and use the correct display scale for this device
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
        }
    }
    
    // MARK: - updateOutlet
    private func updateOutlet() {
        outletViewModel.updateOutlet(outlet)
    }
}

#Preview {    
    OutletCellView(outlet: OutletModel(id: UUID(),
                                                 name: "Cat Outlet",
                                                 rssUrl: "www.cats1.com",
                                                 tag: "purple",
                                                 feedItemsCount: 125))
    .frame(height: 100)
    .padding()
    .environmentObject(OutletViewModel(coreDataManager: CoreDataManager.shared))
}
