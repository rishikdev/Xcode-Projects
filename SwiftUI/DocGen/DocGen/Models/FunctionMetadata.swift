//
//  FunctionMetadata.swift
//  DocGen
//
//  Created by Rishik Dev on 11/10/26.
//

import Foundation

struct FunctionMetadata {
    let name: String
    let parameters: [Parameter]
    let returnType: String
    let doesThrow: Bool
}

struct Parameter {
    let parameterName: String
    let type: String
}
