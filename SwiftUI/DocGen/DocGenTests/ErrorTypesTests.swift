//
//  ErrorTypesTests.swift
//  DocGen
//
//  Created by Rishik Dev on 21/10/26.
//

import Testing
@testable import DocGen

@Suite("Error Types Tests")
struct ErrorTypesTests {

    @Test("SyntaxError cases provide correct error descriptions")
    func syntaxErrorDescriptions() {
        #expect(
            SyntaxError.functionNotFound.errorDescription ==
            "Could not find a function in the copied text."
        )
        #expect(
            SyntaxError.functionMissingBody.errorDescription ==
            "Could not find the function body."
        )
        #expect(
            SyntaxError.functionSyntacticallyInvalid.errorDescription ==
            "Could not find a syntactically valid function."
        )
    }

    @Test("AIManagerError cases provide correct error descriptions")
    func aiManagerErrorDescriptions() {
        #expect(
            AIManagerError.modelNotLoaded.errorDescription ==
            "Model not loaded. Please wait for initialisation."
        )
        #expect(
            AIManagerError.bundleResourceNotFound.errorDescription ==
            "Could not find model resources in the application bundle."
        )
    }
}
