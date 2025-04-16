//
//  ViewExtensions.swift
//  Pickleball
//
//  Created by Rishik Dev on 18/11/24.
//

import Foundation
import SwiftUI

extension View {
    public func roundGrayBackground() -> some View {
        self
            .padding()
            .background(Color(uiColor: .systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: Constants.Spacing.small.rawValue))
    }
}
