// Copyright © 2023 Snap, Inc. All rights reserved.

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
@testable import SpyableMacro

final class FreeMacroTests: XCTestCase {
    private let sut = ["FreeMacro": FreeMacro.self]

    func testMacro_0() {
        assertMacroExpansion(
            #"#FreeMacro("public protocol ServiceProtocol {}")"#,
            expandedSource: "",
            macros: sut
        )
    }

    func testMacro_1() {
        assertMacroExpansion(
            #"""
            #FreeMacro("""
            import BC

            public protocol ServiceProtocol {
                var name: String {
                    get
                }
                var anyProtocol: any Codable {
                    get
                    set
                }
                var secondName: String? {
                    get
                }
                var added: () -> Void {
                    get
                    set
                }
                var removed: (() -> Void)? {
                    get
                    set
                }

                func initialize(name: String, secondName: String?)
                func fetchConfig() async throws -> [String: String]
                func fetchData(_ name: (String, count: Int)) async -> (() -> Void)
            }
            """)
            """#,
            expandedSource: """
            
            """,
            macros: sut
        )
    }
}
