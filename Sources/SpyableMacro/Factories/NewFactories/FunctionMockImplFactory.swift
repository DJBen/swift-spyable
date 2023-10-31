// Copyright © 2023 Snap, Inc. All rights reserved.

import SwiftSyntax
import SwiftSyntaxBuilder

/// FunctionImplFactory designs to generate function implementations for the generated mocked class.
/// The
struct FunctionMockImplFactory {
    func declaration(
        protocolDecl: ProtocolDeclSyntax,
        protocolFunctionDeclaration: FunctionDeclSyntax
    ) throws -> FunctionDeclSyntax {
        // Append scope modifier to the function (public, internal, ...)
        var modifiers = protocolFunctionDeclaration.modifiers
        modifiers.clearScopeModifier()
        if let scopeModifier = protocolDecl.modifiers.scopeModifier {
            modifiers.append(scopeModifier.trimmed)
        }
        return try FunctionDeclSyntax(
            attributes: protocolFunctionDeclaration.attributes,
            modifiers: modifiers,
            funcKeyword: protocolFunctionDeclaration.funcKeyword.trimmed,
            name: protocolFunctionDeclaration.name,
            genericParameterClause: protocolFunctionDeclaration.genericParameterClause,
            signature: protocolFunctionDeclaration.signature,
            genericWhereClause: protocolFunctionDeclaration.genericWhereClause,
            bodyBuilder: {
                let parameters = protocolFunctionDeclaration.signature.parameterClause.parameters
                let expectationsVariableName = "expectations_\(protocolFunctionDeclaration.name)"
                try ForStmtSyntax(
                    "for (stub, _) in \(raw: expectationsVariableName).reversed()"
                ) {
                    let invocationInitializerParams = parameters.map { (funcParamSyntax: FunctionParameterSyntax) in
                        let name = (funcParamSyntax.secondName ?? funcParamSyntax.firstName).text
                        if funcParamSyntax.type.isFunctionTypeSyntax {
                            return "\(name): ()"
                        } else {
                            return "\(name): \(name)"
                        }
                    }.joined(separator: ",\n")
                    DeclSyntax("""
                    let invocation = Invocation_\(protocolFunctionDeclaration.name)(
                    \(raw: invocationInitializerParams)
                    )
                    """)
                    ExprSyntax("invocations_\(protocolFunctionDeclaration.name).append(invocation)")
                    let ifStmtCondition = parameters.compactMap { (funcParamSyntax: FunctionParameterSyntax) in
                        let name = (funcParamSyntax.secondName ?? funcParamSyntax.firstName).text
                        if funcParamSyntax.type.isFunctionTypeSyntax {
                            return nil
                        }

                        return "stub.\(name).predicate(\(name))"
                    }
                    .joined(separator: " && ")

                    try IfExprSyntax("if \(raw: ifStmtCondition)") {
                        let namesAndParams = parameters.compactMap {
                            if let functionTypeSyntax = $0.type.underlyingFunctionTypeSyntax {
                                return (($0.secondName ?? $0.firstName).text, functionTypeSyntax)
                            } else {
                                return nil
                            }
                        }
                        for (name, funcParam) in namesAndParams {
                            if funcParam.parameters.isEmpty {
                                try IfExprSyntax("if let _ = stub.\(raw: name)") {
                                    ExprSyntax("\(raw: name)()")
                                }
                            } else {
                                try IfExprSyntax("if let invoke_\(raw: name) = stub.\(raw: name)") {
                                    let params = (0..<funcParam.parameters.count).map {
                                        "invoke_\(name).param\($0 + 1)"
                                    }.joined(separator: ", ")
                                    ExprSyntax("\(raw: name)(\(raw: params))")
                                }
                            }
                        }
                        if let _ = protocolFunctionDeclaration.signature.returnClause {
                            ReturnStmtSyntax(expression: ExprSyntax("stub.returnValue"))
                        }
                    }
                }

                if let _ = protocolFunctionDeclaration.signature.returnClause {
                    // Generate a parameter list for the fatalError
                    // Invocations don't include function types, so we omit them.
                    // e.g. performRequest(request: \(request), reportId: \(reportId), includeLogs: \(includeLogs), onSuccess:…, onPermanentFailure:…)
                    let fatalErrorParams = parameters.map { (funcParamSyntax: FunctionParameterSyntax) in
                        let name = (funcParamSyntax.secondName ?? funcParamSyntax.firstName).text
                        if funcParamSyntax.type.isFunctionTypeSyntax {
                            return "\(name): …"
                        } else {
                            return "\(name): \\(\(name))"
                        }
                    }.joined(separator: ", ")

                    ExprSyntax(#"""
                    fatalError("Unexpected invocation of performRequest(\#(raw: fatalErrorParams)). Could not continue without a return value. Did you stub it?")
                    """#)
                }
            }
        )
    }

}

extension TypeSyntax {
    /// Whether it is a function type syntax or attributed syntax that has an underlying function type syntax.
    /// e.g. `@escaping () -> Void` or `(Int, String) -> Void`
    var isFunctionTypeSyntax: Bool {
        if self.is(FunctionTypeSyntax.self) {
            return true
        }
        if let attr = self.as(AttributedTypeSyntax.self) {
            return attr.baseType.is(FunctionTypeSyntax.self)
        }
        return false
    }

    var underlyingFunctionTypeSyntax: FunctionTypeSyntax? {
        if let funcTypeSyntax = self.as(FunctionTypeSyntax.self) {
            return funcTypeSyntax
        }
        if let attr = self.as(AttributedTypeSyntax.self), let funcTypeSyntax = attr.baseType.as(FunctionTypeSyntax.self) {
            return funcTypeSyntax
        }
        return nil
    }
}

extension DeclModifierListSyntax {
    var scopeModifier: DeclModifierSyntax? {
        first(where: {
            $0.name.kind == TokenSyntax.keyword(.public).kind ||
            $0.name.kind == TokenSyntax.keyword(.private).kind ||
            $0.name.kind == TokenSyntax.keyword(.fileprivate).kind ||
            $0.name.kind == TokenSyntax.keyword(.internal).kind ||
            $0.name.kind == TokenSyntax.keyword(.open).kind
        })
    }

    mutating func clearScopeModifier() {
        self = filter {
            $0.name.kind != TokenSyntax.keyword(.public).kind ||
            $0.name.kind != TokenSyntax.keyword(.private).kind ||
            $0.name.kind != TokenSyntax.keyword(.fileprivate).kind ||
            $0.name.kind != TokenSyntax.keyword(.internal).kind ||
            $0.name.kind != TokenSyntax.keyword(.open).kind
        }
    }
}
