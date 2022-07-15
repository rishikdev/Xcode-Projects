//
//  SharedData.swift
//  MyNotes+
//
//  Created by Rishik Dev on 12/07/22.
//

import SwiftUI

struct SharedData: Hashable, Identifiable
{
    let noteID: UUID
    let noteTitle: String
    let noteText: String
    let noteTag: String
    let noteCardColour: String
    let noteDate: Date
    let isNoteLocked: Bool
    
    var id: UUID
    {
        noteID
    }
}
