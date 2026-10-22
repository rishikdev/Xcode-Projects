//
//  FunctionMetadataExtractorTests.swift
//  DocGen
//
//  Created by Rishik Dev on 21/10/26.
//

import Testing
@testable import DocGen

@Suite("Function Metadata Extractor Tests")
struct FunctionMetadataExtractorTests {

    @Test("Extracts metadata from a simple function with no parameters or return type")
    func simpleFunctionWithoutParametersOrReturn() throws {
        let code = """
        func doSomething() {
            print("Hello, world!")
        }
        """

        let metadata = try FunctionMetadataExtractor.extractMetadata(from: code)

        #expect(metadata.name == "doSomething")
        #expect(metadata.parameters.isEmpty)
        #expect(metadata.returnType == "Void")
        #expect(!metadata.doesThrow)
    }

    @Test("Extracts metadata from function with standard parameters and return type")
    func functionWithStandardParametersAndReturnType() throws {
        let code = """
        func calculateSum(first: Int, second: Int) -> Int {
            return first + second
        }
        """

        let metadata = try FunctionMetadataExtractor.extractMetadata(from: code)

        #expect(metadata.name == "calculateSum")
        #expect(metadata.parameters.count == 2)
        #expect(metadata.parameters[0].parameterName == "first")
        #expect(metadata.parameters[0].type == "Int")
        #expect(metadata.parameters[1].parameterName == "second")
        #expect(metadata.parameters[1].type == "Int")
        #expect(metadata.returnType == "Int")
        #expect(!metadata.doesThrow)
    }

    @Test("Extracts metadata from function with wildcard argument labels")
    func functionWithWildcardArgumentLabels() throws {
        let code = """
        func multiply(_ a: Double, _ b: Double) -> Double {
            return a * b
        }
        """

        let metadata = try FunctionMetadataExtractor.extractMetadata(from: code)

        #expect(metadata.name == "multiply")
        #expect(metadata.parameters.count == 2)
        #expect(metadata.parameters[0].parameterName == "a")
        #expect(metadata.parameters[0].type == "Double")
        #expect(metadata.parameters[1].parameterName == "b")
        #expect(metadata.parameters[1].type == "Double")
        #expect(metadata.returnType == "Double")
        #expect(!metadata.doesThrow)
    }

    @Test("Extracts metadata from function with custom argument labels")
    func functionWithCustomArgumentLabels() throws {
        let code = """
        func send(message text: String, to recipient: String) -> Bool {
            return true
        }
        """

        let metadata = try FunctionMetadataExtractor.extractMetadata(from: code)

        #expect(metadata.name == "send")
        #expect(metadata.parameters.count == 2)
        #expect(metadata.parameters[0].parameterName == "text")
        #expect(metadata.parameters[0].type == "String")
        #expect(metadata.parameters[1].parameterName == "recipient")
        #expect(metadata.parameters[1].type == "String")
        #expect(metadata.returnType == "Bool")
        #expect(!metadata.doesThrow)
    }

    @Test("Extracts metadata from throwing function")
    func throwingFunction() throws {
        let code = """
        func loadConfiguration(from path: String) throws -> [String: String] {
            return [:]
        }
        """

        let metadata = try FunctionMetadataExtractor.extractMetadata(from: code)

        #expect(metadata.name == "loadConfiguration")
        #expect(metadata.parameters.count == 1)
        #expect(metadata.parameters[0].parameterName == "path")
        #expect(metadata.parameters[0].type == "String")
        #expect(metadata.returnType == "[String: String]")
        #expect(metadata.doesThrow)
    }

    @Test("Extracts metadata from async throwing function")
    func asyncThrowingFunction() throws {
        let code = """
        func fetchUserData(userId: UUID) async throws -> [String: String] {
            return [:]
        }
        """

        let metadata = try FunctionMetadataExtractor.extractMetadata(from: code)

        #expect(metadata.name == "fetchUserData")
        #expect(metadata.parameters.count == 1)
        #expect(metadata.parameters[0].parameterName == "userId")
        #expect(metadata.parameters[0].type == "UUID")
        #expect(metadata.returnType == "[String: String]")
        #expect(metadata.doesThrow)
    }

    @Test("Extracts metadata with explicit Void return type")
    func explicitVoidReturnType() throws {
        let code = """
        func logActivity(event: String) -> Void {
            NSLog("%@", event)
        }
        """

        let metadata = try FunctionMetadataExtractor.extractMetadata(from: code)

        #expect(metadata.name == "logActivity")
        #expect(metadata.returnType == "Void")
        #expect(!metadata.doesThrow)
    }

    @Test("Extracts metadata with complex closure and optional parameter types")
    func complexParameterTypes() throws {
        let code = """
        func requestData(query: String?, completion: @escaping (Result<[Int], Error>) -> Void) {
            completion(.success([]))
        }
        """

        let metadata = try FunctionMetadataExtractor.extractMetadata(from: code)

        #expect(metadata.name == "requestData")
        #expect(metadata.parameters.count == 2)
        #expect(metadata.parameters[0].parameterName == "query")
        #expect(metadata.parameters[0].type == "String?")
        #expect(metadata.parameters[1].parameterName == "completion")
        #expect(metadata.parameters[1].type == "@escaping (Result<[Int], Error>) -> Void")
        #expect(metadata.returnType == "Void")
        #expect(!metadata.doesThrow)
    }

    @Test("Throws functionNotFound when input is empty or whitespace")
    func emptyInputThrowsFunctionNotFound() {
        #expect(throws: SyntaxError.functionNotFound) {
            try FunctionMetadataExtractor.extractMetadata(from: "")
        }
        #expect(throws: SyntaxError.functionNotFound) {
            try FunctionMetadataExtractor.extractMetadata(from: "   \n\t  ")
        }
    }

    @Test("Throws functionNotFound when input contains non-function declarations")
    func nonFunctionDeclarationThrowsFunctionNotFound() {
        #expect(throws: SyntaxError.functionNotFound) {
            try FunctionMetadataExtractor.extractMetadata(from: "let answer = 42")
        }
        #expect(throws: SyntaxError.functionNotFound) {
            try FunctionMetadataExtractor.extractMetadata(from: "struct Item { var id: Int }")
        }
        #expect(throws: SyntaxError.functionNotFound) {
            try FunctionMetadataExtractor.extractMetadata(from: "class Manager {}")
        }
    }

    @Test("Throws functionMissingBody when function signature has no body")
    func functionWithoutBodyThrowsFunctionMissingBody() {
        let code = "func calculateValue(input: Int) -> Int"
        #expect(throws: SyntaxError.functionMissingBody) {
            try FunctionMetadataExtractor.extractMetadata(from: code)
        }
    }

    @Test("Throws syntax error when input is syntactically invalid")
    func invalidSyntaxThrowsError() {
        let code = "func (invalid Syntax"
        #expect(throws: SyntaxError.self) {
            try FunctionMetadataExtractor.extractMetadata(from: code)
        }
    }
}
