//
//  MyNotesPlusWidgetFamily.swift
//  MyNotesPlusIntents
//
//  Created by Rishik Dev on 14/07/22.
//

import WidgetKit
import SwiftUI

@main
struct MyNotesPlusWidgetFamily: WidgetBundle
{
    @WidgetBundleBuilder
    var body: some Widget
    {
        MyNotesPlusSmallWidget()
        MyNotesPlusMediumWidget()
        MyNotesPlusLargeWidget()
    }
}
