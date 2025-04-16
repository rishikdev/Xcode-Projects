//
//  ViewExtension.swift
//  MyNotesPlus
//
//  Created by Rishik Dev on 13/07/23.
//

import SwiftUI

extension View {
    public func customNavigationViewStyle<T, U>(if condition: Bool, then modifierT: T, else modifierU: U) -> some View where T: ViewModifier, U: ViewModifier {
        Group {
            if(condition) {
                modifier(modifierT)
            } else {
                modifier(modifierU)
            }
        }
    }
}
