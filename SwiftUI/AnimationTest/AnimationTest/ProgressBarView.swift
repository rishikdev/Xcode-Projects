//
//  ProgressBarView.swift
//  AnimationTest
//
//  Created by Rishik Dev on 16/07/24.
//

import SwiftUI

struct ProgressBarView: View {
    var body: some View {
        HStack {
            Text("3:00")
            ProgressView(value: 180, total: 300)
                .progressViewStyle(.linear)
            Text("5:00")
        }
        .font(.caption)
    }
}

#Preview {
    ProgressBarView()
}
