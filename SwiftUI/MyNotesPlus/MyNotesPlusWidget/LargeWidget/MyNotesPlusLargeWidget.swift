//
//  MyNotesPlusLargeWidget.swift
//  MyNotesPlusWidgetExtension
//
//  Created by Rishik Dev on 14/07/22.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct MyNotesPlusLargeWidget: Widget
{
    let kind: String = "MyNotesPlusLargeWidget"
    @StateObject var myNotesViewModel = MyNotesViewModel()

    var body: some WidgetConfiguration
    {
        IntentConfiguration(kind: kind, intent: LargeWidgetConfigurationIntent.self, provider: LargeWidgetIntentTimelineProvider())
        {
            entry in

            LargeWidgetView(entry: entry)
        }
        .configurationDisplayName("List of notes")
        .description("You can see a list of your notes here or you can choose a particular note also.")
        .supportedFamilies([.systemLarge])
        .contentMarginsDisabled()
    }
}

struct MyNotesPlusLargeWidget_Previews: PreviewProvider
{
    static var previews: some View
    {
        LargeWidgetView(entry: LargeWidgetIntentSimpleEntry(date: Date(), configuration: LargeWidgetConfigurationIntent(), sharedData: MyNotesViewModel().sharedDataArray))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
