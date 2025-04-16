//
//  FilterClass.swift
//  My Notes
//
//  Created by Rishik Dev on 19/03/22.
//

import Foundation
import SwiftUI

class QuickSettingsClass: ObservableObject
{
    @AppStorage("currentFilter") var currentFilter = "🔴🟢🔵🟡⚪️"
    @AppStorage("isUsingBiometric") var isUsingBiometric: Bool = false
    @AppStorage("sortInAscending") var sortInAscending: Bool = false
    @AppStorage("currentSortByKey") var currentSortByKey: String = "noteDate"
    @AppStorage("sortByKey") var sortByKey: SortByEnum = .noteDate
}
