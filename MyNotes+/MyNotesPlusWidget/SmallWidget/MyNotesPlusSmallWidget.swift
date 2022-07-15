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
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider())
        {
            entry in
            
            SmallWidgetView(entry: entry)
        }
        .configurationDisplayName("Note")
        .description("You can see one of your notes here.")
        .supportedFamilies([.systemSmall])
    }
}

struct MyNotesPlusSmallWidget_Previews: PreviewProvider
{
    static var previews: some View
    {
        SmallWidgetView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), sharedData: MyNotesViewModel().sharedDataArray))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
