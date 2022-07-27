//
//  LargeWidgetIntentTimelineProvider.swift
//  MyNotesPlusWidgetExtension
//
//  Created by Rishik Dev on 14/07/22.
//

import WidgetKit

struct LargeWidgetIntentTimelineProvider: IntentTimelineProvider
{
    @MainActor let sharedDataArray = MyNotesViewModel().sharedDataArray
    
    func placeholder(in context: Context) -> LargeWidgetIntentSimpleEntry
    {
        LargeWidgetIntentSimpleEntry(date: Date(), configuration: LargeWidgetConfigurationIntent(), sharedData: sharedDataArray)
    }

    func getSnapshot(for configuration: LargeWidgetConfigurationIntent, in context: Context, completion: @escaping (LargeWidgetIntentSimpleEntry) -> ())
    {
        let entry = LargeWidgetIntentSimpleEntry(date: Date(), configuration: configuration, sharedData: sharedDataArray)
        completion(entry)
    }

    @MainActor
    func getTimeline(for configuration: LargeWidgetConfigurationIntent, in context: Context, completion: @escaping (Timeline<LargeWidgetIntentSimpleEntry>) -> ())
    {
        var entries: [LargeWidgetIntentSimpleEntry] = []
        
        let currentDate = Date()
        let sharedDataArray = MyNotesViewModel().sharedDataArray
        
        let entry = LargeWidgetIntentSimpleEntry(date: currentDate, configuration: configuration, sharedData: sharedDataArray)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
