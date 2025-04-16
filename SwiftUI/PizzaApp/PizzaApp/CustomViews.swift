//
//  CustomViews.swift
//  PizzaApp
//
//  Created by Rishik Dev on 12/05/23.
//

import SwiftUI

struct CustomViews: View {
    @State private var isExpandedDismissableViews: Bool = true
    @State private var isExpandedWebViews: Bool = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                DisclosureGroup("Dismissable Views", isExpanded: $isExpandedDismissableViews) {
                    ForEach(Data.getDummyData(), id: \.id) { datum in
                        DismissableView(data: datum)
                    }
                }
                
                DisclosureGroup("Web Views", isExpanded: $isExpandedWebViews) {
                    WebView()
                }
            }
            .navigationTitle("Views")
            .padding()
        }
    }
}

struct CustomViews_Previews: PreviewProvider {
    static var previews: some View {
        CustomViews()
    }
}
