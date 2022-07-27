//
//  TimelineProvider.swift
//  MyNotesPlusWidgetExtension
//
//  Created by Rishik Dev on 08/07/22.
//

import WidgetKit
import CoreData

struct SmallWidgetIntentTimelineProvider: IntentTimelineProvider
{
    @MainActor let sharedDataArray = MyNotesViewModel().sharedDataArray
    
    func placeholder(in context: Context) -> SmallWidgetIntentSimpleEntry
    {
        SmallWidgetIntentSimpleEntry(date: Date(), configuration: SmallWidgetConfigurationIntent(), sharedData: sharedDataArray)
    }

    func getSnapshot(for configuration: SmallWidgetConfigurationIntent, in context: Context, completion: @escaping (SmallWidgetIntentSimpleEntry) -> ())
    {
        let entry = SmallWidgetIntentSimpleEntry(date: Date(), configuration: configuration, sharedData: sharedDataArray)
        completion(entry)
    }

    @MainActor
    func getTimeline(for configuration: SmallWidgetConfigurationIntent, in context: Context, completion: @escaping (Timeline<SmallWidgetIntentSimpleEntry>) -> ())
    {
        var entries: [SmallWidgetIntentSimpleEntry] = []
        
        let currentDate = Date()
        let sharedDataArray = MyNotesViewModel().sharedDataArray
        
        let entry = SmallWidgetIntentSimpleEntry(date: currentDate, configuration: configuration, sharedData: sharedDataArray)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
