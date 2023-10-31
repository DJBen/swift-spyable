import SwiftSyntax
import SwiftSyntaxMacros

public enum GenerateTestMockMacro: PeerMacro {
    private static let extractor = Extractor()

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let protocolDeclaration = try extractor.extractProtocolDeclaration(from: declaration)
//
//        let spyClassDeclaration = spyFactory.classDeclaration(for: protocolDeclaration)
//
//        return [DeclSyntax(spyClassDeclaration)]
        return []
    }
}

//struct MockedClassDeclFactory {
//    func make(typeName: TokenSyntax, from classDecl: ClassDeclSyntax) -> ClassDeclSyntax {
//        ClassDeclSyntax(
//            identifier: typeName,
//            memberBlockBuilder: {
//                let variables = classDecl.memberBlock.members
//                    .compactMap { $0.decl.as(VariableDeclSyntax.self) }
//                MockVariableDeclarationFactory().mockVariableDeclarations(variables)
//
//                let functions = classDecl.memberBlock.members
//                    .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
//
//                let functionsFactory = FunctionMockableDeclarationFactory()
//                functionsFactory.callTrackerDeclarations(functions)
//                functionsFactory.mockImplementations(for: functions)
//            }
//        )
//    }
//}
