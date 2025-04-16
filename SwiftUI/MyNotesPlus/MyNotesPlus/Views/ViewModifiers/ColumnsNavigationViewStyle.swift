//
//  ColumnsNavigationViewStyle.swift
//  MyNotesPlus
//
//  Created by Rishik Dev on 13/07/23.
//

import SwiftUI

struct ColumnsNavigationViewStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.navigationViewStyle(.columns)
    }
}
