//
//  SimpleEntry.swift
//  MyNotesPlusWidgetExtension
//
//  Created by Rishik Dev on 08/07/22.
//

import WidgetKit

struct SmallWidgetIntentSimpleEntry: TimelineEntry
{
    let date: Date
    let configuration: SmallWidgetConfigurationIntent
    let sharedData: [SharedData]
}
