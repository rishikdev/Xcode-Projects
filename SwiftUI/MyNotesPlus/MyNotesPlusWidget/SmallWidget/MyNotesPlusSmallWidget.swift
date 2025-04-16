//
//  MyNotesPlusWidget.swift
//  MyNotesPlusWidget
//
//  Created by Rishik Dev on 08/07/22.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct MyNotesPlusSmallWidget: Widget
{
    let kind: String = "MyNotesPlusSmallWidget"
    @StateObject var myNotesViewModel = MyNotesViewModel()

    var body: some WidgetConfiguration
    {
        IntentConfiguration(kind: kind, intent: SmallWidgetConfigurationIntent.self, provider: SmallWidgetIntentTimelineProvider())
        {
            entry in
            
            SmallWidgetView(entry: entry)
        }
        .configurationDisplayName("Note")
        .description("You can see one of your notes here.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

struct MyNotesPlusSmallWidget_Previews: PreviewProvider
{
    static var previews: some View
    {
        SmallWidgetView(entry: SmallWidgetIntentSimpleEntry(date: Date(), configuration: SmallWidgetConfigurationIntent(), sharedData: MyNotesViewModel().sharedDataArray))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
