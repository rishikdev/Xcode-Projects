//
//  SimpleEntry.swift
//  MyNotesPlusWidgetExtension
//
//  Created by Rishik Dev on 08/07/22.
//

import WidgetKit

struct SimpleEntry: TimelineEntry
{
    let date: Date
    let configuration: ConfigurationIntent
    let sharedData: [SharedData]
}
