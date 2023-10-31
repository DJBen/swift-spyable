// Copyright © 2023 Snap, Inc. All rights reserved.
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

public enum FreeMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let protocolDeclExpr = node.argumentList.first?.expression.as(StringLiteralExprSyntax.self)
        let protocolDeclStr = protocolDeclExpr!.segments.map {
            if case let .stringSegment(line) = $0 {
                line.content.text
            } else {
                fatalError("Non-string passed to #FreeMacro")
            }
        }.joined()
        let sourceFileSyntax = SourceFileSyntax("\(raw: protocolDeclStr)")
        let protocolDecls = sourceFileSyntax.statements.compactMap { codeBlockItemSyntax in
            if let protocolDecl = codeBlockItemSyntax.item.as(ProtocolDeclSyntax.self) {
                return protocolDecl
            } else {
                return nil
            }
        }.filter {
            $0.name.text == "ServiceProtocol"
        }
        print(protocolDecls.first!.debugDescription)
        return [
        ]
    }
}
