//
//  AIManagerTests.swift
//  DocGen
//
//  Created by Rishik Dev on 21/10/26.
//

import Testing
@testable import DocGen

@Suite("AI Manager Tests")
struct AIManagerTests {

    @Test("AIManager throws modelNotLoaded when getDocumentation is called before model initialisation")
    func getDocumentationThrowsWhenModelNotLoaded() async {
        let manager = AIManager.shared
        let metadata = FunctionMetadata(
            name: "sample",
            parameters: [],
            returnType: "Void",
            doesThrow: false
        )

        await #expect(throws: AIManagerError.modelNotLoaded) {
            try await manager.getDocumentation(for: "func sample() {}", withMetadata: metadata)
        }
    }
}
