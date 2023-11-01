import XCTest
@testable import SpyableMacro
import SwiftSyntax

final class FunctionMockImplFactoryTests: XCTestCase {
    func testDeclaration() throws {
        let result = try FunctionMockImplFactory().declaration(
            protocolDecl: TestCases.Case1.protocolDecl,
            protocolFunctionDeclaration: TestCases.Case1.functionDecl
        )

        assertBuildResult(
            result,
            #"""
            @objc public func performRequest(
                request: URLRequest,
                reportId: String,
                includeLogs: Bool,
                onSuccess: @escaping () -> Void,
                onPermanentFailure: @escaping (Error, String) -> Void
            ) -> String {
                for (stub, _) in expectations_performRequest.reversed() {
                    let invocation = Invocation_performRequest(
                        request: request,
                        reportId: reportId,
                        includeLogs: includeLogs,
                        onSuccess: (),
                        onPermanentFailure: ()
                    )
                    invocations_performRequest.append(invocation)
                    if stub.request.predicate(request) && stub.reportId.predicate(reportId) && stub.includeLogs.predicate(includeLogs) {
                        if let _ = stub.onSuccess {
                            onSuccess()
                        }
                        if let invoke_onPermanentFailure = stub.onPermanentFailure {
                            onPermanentFailure(invoke_onPermanentFailure.param1, invoke_onPermanentFailure.param2)
                        }
                        return stub.returnValue
                    }
                }
                fatalError("Unexpected invocation of performRequest(request: \(request), reportId: \(reportId), includeLogs: \(includeLogs), onSuccess: …, onPermanentFailure: …). Could not continue without a return value. Did you stub it?")
            }
            """#
        )
    }
}
