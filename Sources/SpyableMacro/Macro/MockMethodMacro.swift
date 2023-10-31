// Copyright © 2023 Snap, Inc. All rights reserved.

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Func With unique name.
public enum MockMethodMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
//        let protocolDeclaration = try extractor.extractProtocolDeclaration(from: declaration)
//
//        let spyClassDeclaration = spyFactory.classDeclaration(for: protocolDeclaration)
//
//        return [DeclSyntax(spyClassDeclaration)]
        return []
    }
}
