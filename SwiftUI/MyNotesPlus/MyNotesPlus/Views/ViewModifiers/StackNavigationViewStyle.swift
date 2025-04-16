//
//  StackNavigationViewStyle.swift
//  MyNotesPlus
//
//  Created by Rishik Dev on 13/07/23.
//

import SwiftUI

struct StackNavigationViewStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.navigationViewStyle(.stack)
    }
}
