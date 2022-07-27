//
//  MediumWidgetIntentTimelineProvider.swift
//  MyNotes+
//
//  Created by Rishik Dev on 14/07/22.
//

import WidgetKit

struct MediumWidgetIntentTimelineProvider: IntentTimelineProvider
{
    @MainActor let sharedDataArray = MyNotesViewModel().sharedDataArray
    
    func placeholder(in context: Context) -> MediumWidgetIntentSimpleEntry
    {
        MediumWidgetIntentSimpleEntry(date: Date(), configuration: MediumWidgetConfigurationIntent(), sharedData: sharedDataArray)
    }

    func getSnapshot(for configuration: MediumWidgetConfigurationIntent, in context: Context, completion: @escaping (MediumWidgetIntentSimpleEntry) -> ())
    {
        let entry = MediumWidgetIntentSimpleEntry(date: Date(), configuration: configuration, sharedData: sharedDataArray)
        completion(entry)
    }

    @MainActor
    func getTimeline(for configuration: MediumWidgetConfigurationIntent, in context: Context, completion: @escaping (Timeline<MediumWidgetIntentSimpleEntry>) -> ())
    {
        var entries: [MediumWidgetIntentSimpleEntry] = []
        
        let currentDate = Date()
        let sharedDataArray = MyNotesViewModel().sharedDataArray
        
        let entry = MediumWidgetIntentSimpleEntry(date: currentDate, configuration: configuration, sharedData: sharedDataArray)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
