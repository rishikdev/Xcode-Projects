//
//  TimelineProvider.swift
//  MyNotesPlusWidgetExtension
//
//  Created by Rishik Dev on 08/07/22.
//

import WidgetKit
import CoreData

struct Provider: IntentTimelineProvider
{
    @MainActor let sharedDataArray = MyNotesViewModel().sharedDataArray
    
    func placeholder(in context: Context) -> SimpleEntry
    {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), sharedData: sharedDataArray)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ())
    {
        let entry = SimpleEntry(date: Date(), configuration: configuration, sharedData: sharedDataArray)
        completion(entry)
    }

    @MainActor
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ())
    {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        let sharedDataArray = MyNotesViewModel().sharedDataArray
        
        let entry = SimpleEntry(date: currentDate, configuration: configuration, sharedData: sharedDataArray)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
