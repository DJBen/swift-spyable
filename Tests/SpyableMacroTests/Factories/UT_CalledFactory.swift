import XCTest
@testable import SpyableMacro
import SwiftSyntax

final class UT_CalledFactory: XCTestCase {
    func testVariableDeclaration() {
        let variablePrefix = "functionName"

        let result = CalledFactory().variableDeclaration(variablePrefix: variablePrefix)

        assertBuildResult(
            result,
            """
            var functionNameCalled: Bool {
                return functionNameCallsCount > 0
            }
            """
        )
    }

}
