// Copyright © 2023 Snap, Inc. All rights reserved.

import Foundation
import XCTest

@objc
public protocol SCCrashLoggerNetworkExecuting: NSObjectProtocol {
    @objc
    func performRequest(
        request: URLRequest,
        reportId: String,
        includeLogs: Bool,
        onSuccess: @escaping () -> Void,
        onPermanentFailure: @escaping (Error, String) -> Void
    ) -> String
}

//@GenerateMock
//public class SCCrashLoggerNetworkExecutorMock: NSObject {
//
//}

public class SCCrashLoggerNetworkExecutorMock: NSObject, SCCrashLoggerNetworkExecuting {
    public class Invocations_PerformRequest {
        var invocations: [Invocation_performRequest] = []
    }

    // Generated if all non-block params are Equatable.
    public func stub_performRequest(
        request: URLRequest,
        reportId: String,
        includeLogs: Bool,
        onSuccess: InvokeBlock?,
        onPermanentFailure: InvokeBlock2<Error, String>?,
        andReturn value: String
    ) {
        stub_performRequest(
            request: .eq(request),
            reportId: .eq(reportId),
            includeLogs: .eq(includeLogs),
            onSuccess: onSuccess,
            onPermanentFailure: onPermanentFailure,
            andReturn: value
        )
    }

    // Always generated.
    public func stub_performRequest(
        request: Matching<URLRequest>,
        reportId: Matching<String>,
        includeLogs: Matching<Bool>,
        onSuccess: InvokeBlock?,
        onPermanentFailure: InvokeBlock2<Error, String>?,
        andReturn value: String
    ) {
        expect_performRequest(
            request: request,
            reportId: reportId,
            includeLogs: includeLogs, 
            onSuccess: onSuccess,
            onPermanentFailure: onPermanentFailure,
            andReturn: value,
            expectation: nil
        )
    }

    public func expect_performRequest(
        request: Matching<URLRequest>,
        reportId: Matching<String>,
        includeLogs: Matching<Bool>,
        onSuccess: InvokeBlock?,
        onPermanentFailure: InvokeBlock2<Error, String>?,
        andReturn value: String,
        expectation: Expectation?
    ) {
        let stub = Stub_performRequest(
            request: request,
            reportId: reportId,
            includeLogs: includeLogs,
            onSuccess: onSuccess,
            onPermanentFailure: onPermanentFailure,
            returnValue: value
        )
        expectations_performRequest.append((stub, expectation))
    }

    public func verify_performRequest() {
        var invocations = invocations_performRequest
        for (stub, expectation) in expectations_performRequest.reversed() {
            guard let expectation = expectation else {
                continue
            }
            var matchedCalls = 0
            var index = 0
            while index < invocations.count {
                if stub.matches(invocations[index]) {
                    invocations.remove(at: index)
                    matchedCalls += 1
                } else {
                    index += 1
                }
            }

            expectation.callCountPredicate.verify(
                methodSignature:"""
                performRequest(
                    request: \(stub.request.description),
                    reportId: \(stub.reportId.description),
                    includeLogs: \(stub.includeLogs.description),
                    onSuccess: @escaping () -> Void,
                    onPermanentFailure: @escaping (Error, String) -> Void
                )
                """,
                callCount: matchedCalls
            )
        }

        for invocation in invocations {
            XCTFail(
            """
            These invocations are made but not expected:
            performRequest(
                request: \(invocation.request),
                reportId: \(invocation.reportId),
                includeLogs: \(invocation.includeLogs),
                onSuccess: (...),
                onPermanentFailure: (...)
            )
            """
            )
        }
    }

    public struct Stub_performRequest {
        let request: Matching<URLRequest>
        let reportId: Matching<String>
        let includeLogs: Matching<Bool>
        let onSuccess: InvokeBlock?
        let onPermanentFailure: InvokeBlock2<Error, String>?
        let returnValue: String

        func matches(_ invocation: Invocation_performRequest) -> Bool {
            return request.predicate(invocation.request) &&
            reportId.predicate(invocation.reportId) &&
            includeLogs.predicate(invocation.includeLogs)
        }
    }

    public struct Invocation_performRequest {
        let request: URLRequest
        let reportId: String
        let includeLogs: Bool
        let onSuccess: Void
        let onPermanentFailure: Void
    }

    // Stores the return value mapped from each stub.
    private(set) var expectations_performRequest: [(Stub_performRequest, Expectation?)] = []
    private(set) var invocations_performRequest = [Invocation_performRequest]()

    @objc
    public func performRequest(
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

            if stub.request.predicate(request) &&
                stub.reportId.predicate(reportId) &&
                stub.includeLogs.predicate(includeLogs) {

                if let _ = stub.onSuccess {
                    onSuccess()
                }

                if let invoke_onPermanentFailure = stub.onPermanentFailure {
                    onPermanentFailure(invoke_onPermanentFailure.param1, invoke_onPermanentFailure.param2)
                }

                return stub.returnValue
            }
        }

        fatalError("Unexpected invocation of performRequest(request: \(request), reportId: \(reportId), includeLogs: \(includeLogs), onSuccess:, onPermanentFailure:. Could not continue without a return value. Did you stub it?")
    }
}

