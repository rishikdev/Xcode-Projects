//
//  OperationsEnum.swift
//  RSS
//
//  Created by Rishik Dev on 28/02/2025.
//

import Foundation

enum OperationsEnum: Hashable {
    case fetchLocal(value: String), fetchRemote(value: String), parse(value: String), save(value: String)
}
