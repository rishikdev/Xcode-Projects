//
//  MyNotesPlusWidgetView.swift
//  MyNotesPlusWidgetExtension
//
//  Created by Rishik Dev on 08/07/22.
//

import SwiftUI

struct MyNotesPlusWidgetView : View
{
    var smallWidgetEntry: Provider.Entry
    var mediumWidgetEntry: MediumWidgetIntentSimpleEntry
    var largeWidgetEntry: LargeWidgetIntentSimpleEntry
    
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View
    {
        switch widgetFamily
        {
            case .systemSmall:
                SmallWidgetView(entry: smallWidgetEntry)
                
            case .systemMedium:
                MediumWidgetView(entry: mediumWidgetEntry)
                
            case .systemLarge:
                LargeWidgetView(entry: largeWidgetEntry)
                
            default: Text("This widget size is not supported")
        }
    }
}
