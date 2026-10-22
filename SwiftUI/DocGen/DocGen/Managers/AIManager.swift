//
//  AIManager.swift
//  DocGen
//
//  Created by Rishik Dev on 06/10/26.
//

import Foundation
import MLXLLM
import MLXLMCommon
import MLXHuggingFace
import Tokenizers
import HuggingFace

actor AIManager {
    static let shared = AIManager()
    
    private var container: ModelContainer?
    
    private init() {}
    
    func loadModel() async throws {
        if container != nil { return }
        
        guard let resourceURL = Bundle.main.resourceURL else {
            throw AIManagerError.bundleResourceNotFound
        }
        
        let localConfig = ModelConfiguration(directory: resourceURL)
        self.container = try await LLMModelFactory.shared.loadContainer(
            from: #hubDownloader(),
            using: #huggingFaceTokenizerLoader(),
            configuration: localConfig
        )
    }

    func getDocumentation(for function: String, withMetadata metadata: FunctionMetadata) async throws -> AsyncThrowingStream<String, Error> {
        guard let container = self.container else {
            throw AIManagerError.modelNotLoaded
        }
                
        let prompt = buildPrompt(for: function, metadata: metadata)
        
        let input = UserInput(prompt: prompt)
        
        let lmInput = try await container.prepare(input: input)
        let parameters = GenerateParameters(temperature: 0)
        
        let rawStream = try await container.generate(input: lmInput, parameters: parameters)
        
        return AsyncThrowingStream { continuation in
            Task {
                for await generation in rawStream {
                    if case .chunk(let text) = generation {
                        continuation.yield(text)
                    }
                }
                continuation.finish()
            }
        }
    }
    
    private func buildPrompt(for functionCode: String, metadata: FunctionMetadata) -> String {
        var rules: [String] = []

        if metadata.parameters.isEmpty {
            rules.append("- Parameters: None. Do NOT emit a `- Parameter` or `- Parameters:` section.")
        } else {
            let paramNames = metadata.parameters.map { "\($0.parameterName) (\($0.type))" }.joined(separator: ", ")
            rules.append("- Parameters to document exactly: [\(paramNames)]. Use only these exact parameter names.")
        }

        if metadata.doesThrow {
            rules.append("- Throws: Yes. Include a `- Throws:` section explaining when it throws.")
        } else {
            rules.append("- Throws: None. Do NOT emit a `- Throws:` tag.")
        }

        if metadata.returnType != "Void" {
            rules.append("- Returns: Yes (\(metadata.returnType)). Include a `- Returns:` tag.")
        } else {
            rules.append("- Returns: None. Do NOT emit a `- Returns:` tag.")
        }

        let rulesBlock = rules.joined(separator: "\n")

        return """
        <|im_start|>system
        You are an expert Apple Swift developer writing DocC comments.
        Document the function using ONLY lines starting with "///".
        Always start with the brief description of the function. 

        MANDATORY STRUCTURAL CONSTRAINTS:
        \(rulesBlock)

        Strict output rules:
        - Write only the /// comment block.
        - Never reproduce, rewrite, or append the function body or definition.
        - Do not invent examples or `Usage:` blocks unless requested.<|im_end|>
        <|im_start|>user
        \(functionCode)<|im_end|>
        <|im_start|>assistant
        ///
        """
    }
}
