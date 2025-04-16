//
//  CardViewModifierCollection.swift
//  MyNotesPlus
//
//  Created by Rishik Dev on 13/07/23.
//

import SwiftUI

struct CardViewModifierCollection: ViewModifier {
    let cardWidthiPhone: CGFloat = 150
    let cardHeightiPhone: CGFloat = 230
    let cardWidthiPad: CGFloat = 250
    let cardHeightiPad: CGFloat = 350
        
    let currentDevice = UIDevice.current.userInterfaceIdiom
    
    let myNotesViewModel: MyNotesViewModel
    let noteEntity: MyNotesEntity
    
    func body(content: Content) -> some View {
        content
            .frame(width: currentDevice == .phone ? cardWidthiPhone : cardWidthiPad, height: currentDevice == .phone ? cardHeightiPhone : cardHeightiPad)
            .transition(.scale)
            .contextMenu {
                ContextMenuItems(myNotesViewModel: myNotesViewModel, myNotesEntity: noteEntity, isCardView: true)
                    .transition(.scale)
            }
    }
}
