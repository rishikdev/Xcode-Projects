//
//  MyNotesPlusWidgetView.swift
//  MyNotesPlusWidgetExtension
//
//  Created by Rishik Dev on 08/07/22.
//

import SwiftUI

struct MyNotesPlusWidgetView : View
{
    var smallWidgetEntry: SmallWidgetIntentSimpleEntry
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

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
