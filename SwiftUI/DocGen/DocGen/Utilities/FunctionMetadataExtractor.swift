//
//  FunctionMetadataExtractor.swift
//  DocGen
//
//  Created by Rishik Dev on 09/10/26.
//

import Foundation
import SwiftSyntax
import SwiftParser

struct FunctionMetadataExtractor {

    static func extractMetadata(from function: String) throws -> FunctionMetadata {
        let sourceFile = Parser.parse(source: function)
        
        let firstStatement = sourceFile
            .statements
            .first?
            .item
        
        guard let functionNode = firstStatement?.as(FunctionDeclSyntax.self) else {
            throw SyntaxError.functionNotFound
        }
        
        guard functionNode.body != nil else {
            throw SyntaxError.functionMissingBody
        }
        
        if (functionNode.hasError) {
            throw SyntaxError.functionSyntacticallyInvalid
        }
        
        let functionName = functionNode.name.trimmedDescription
        
        let parameters = functionNode.signature.parameterClause.parameters.map { param in
            let argumentLabel = param.firstName.trimmedDescription
            let parameterName = param.secondName?.trimmedDescription
            
            return Parameter(
                parameterName: parameterName ?? argumentLabel,
                type: param.type.trimmedDescription
            )
        }
        
        let effectSpecifiers = functionNode.signature.effectSpecifiers
        let doesThrow = effectSpecifiers?.throwsClause != nil
        
        let returnType = functionNode.signature.returnClause?.type.trimmedDescription ?? "Void"
        
        return FunctionMetadata(
            name: functionName,
            parameters: parameters,
            returnType: returnType,
            doesThrow: doesThrow
        )
    }
}
