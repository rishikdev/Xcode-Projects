//
//  MyNotesPlusMediumWidget.swift
//  MyNotesPlusWidgetExtension
//
//  Created by Rishik Dev on 14/07/22.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct MyNotesPlusMediumWidget: Widget
{
    let kind: String = "MyNotesPlusMediumWidget"
    @StateObject var myNotesViewModel = MyNotesViewModel()

    var body: some WidgetConfiguration
    {
        IntentConfiguration(kind: kind, intent: MediumWidgetConfigurationIntent.self, provider: MediumWidgetIntentTimelineProvider())
        {
            entry in

            MediumWidgetView(entry: entry)
        }
        .configurationDisplayName("Notes")
        .description("You can see upto two of your notes here.")
        .supportedFamilies([.systemMedium])
    }
}

struct MyNotesPlusMediumWidget_Previews: PreviewProvider
{
    static var previews: some View
    {
        MediumWidgetView(entry: MediumWidgetIntentSimpleEntry(date: Date(), configuration: MediumWidgetConfigurationIntent(), sharedData: MyNotesViewModel().sharedDataArray))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
