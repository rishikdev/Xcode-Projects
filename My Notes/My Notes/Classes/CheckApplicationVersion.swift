//
//  CheckApplicationVersion.swift
//  My Notes
//
//  Created by Rishik Dev on 22/12/22.
//

import Foundation
import SwiftUI

class CheckApplicationVersion: ObservableObject
{
    var currentApplicationVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    @AppStorage("savedAppVersion") var savedAppVersion = "2.1"
}
