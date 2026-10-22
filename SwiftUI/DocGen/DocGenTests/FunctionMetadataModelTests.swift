//
//  FunctionMetadataModelTests.swift
//  DocGen
//
//  Created by Rishik Dev on 21/10/26.
//

import Testing
@testable import DocGen

@Suite("Function Metadata Models Tests")
struct FunctionMetadataModelTests {

    @Test("Parameter model initialises and stores properties accurately")
    func parameterModelProperties() {
        let parameter = Parameter(parameterName: "timeout", type: "TimeInterval")
        #expect(parameter.parameterName == "timeout")
        #expect(parameter.type == "TimeInterval")
    }

    @Test("FunctionMetadata model initialises and stores properties accurately")
    func functionMetadataModelProperties() {
        let params = [
            Parameter(parameterName: "key", type: "String"),
            Parameter(parameterName: "value", type: "Any")
        ]
        let metadata = FunctionMetadata(
            name: "setValue",
            parameters: params,
            returnType: "Bool",
            doesThrow: true
        )

        #expect(metadata.name == "setValue")
        #expect(metadata.parameters.count == 2)
        #expect(metadata.parameters[0].parameterName == "key")
        #expect(metadata.parameters[1].parameterName == "value")
        #expect(metadata.returnType == "Bool")
        #expect(metadata.doesThrow)
    }
}
