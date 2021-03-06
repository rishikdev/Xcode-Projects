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
    @AppStorage("currentFilter") var currentFilter = "๐ด๐ข๐ต๐กโช๏ธ"
    @AppStorage("isUsingBiometric") var isUsingBiometric: Bool = false
    @AppStorage("viewStylePreference") var viewStylePreference: ViewStyleEnum = .list
}
