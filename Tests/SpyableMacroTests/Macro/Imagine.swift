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

public class SCCrashLoggerNetworkExecutorMock: NSObject, SCCrashLoggerNetworkExecuting {
    public class Invocations_PerformRequest {
        var invocations: [Invocation_performRequest] = []
    }

    // Generated if all non-block params are Equatable.
    @discardableResult
    public func stub_performRequest(
        request: URLRequest,
        reportId: String,
        includeLogs: Bool,
        onSuccess: InvokeBlock?,
        onPermanentFailure: InvokeBlock2<Error, String>?,
        andReturn value: String
    ) -> Invocations_PerformRequest {
        return stub_performRequest(
            request: .eq(request),
            reportId: .eq(reportId),
            includeLogs: .eq(includeLogs),
            onSuccess: onSuccess,
            onPermanentFailure: onPermanentFailure,
            andReturn: value
        )
    }

    // Always generated.
    @discardableResult
    public func stub_performRequest(
        request: Matching<URLRequest>,
        reportId: Matching<String>,
        includeLogs: Matching<Bool>,
        onSuccess: InvokeBlock?,
        onPermanentFailure: InvokeBlock2<Error, String>?,
        andReturn value: String
    ) -> Invocations_PerformRequest {
        stubbed_performRequest = Stub_performRequest(
            request: request,
            reportId: reportId,
            includeLogs: includeLogs,
            onSuccess: onSuccess,
            onPermanentFailure: onPermanentFailure,
            returnValue: value
        )

        return invocations_performRequest
    }

    public struct Stub_performRequest {
        let request: Matching<URLRequest>
        let reportId: Matching<String>
        let includeLogs: Matching<Bool>
        let onSuccess: InvokeBlock?
        let onPermanentFailure: InvokeBlock2<Error, String>?
        let returnValue: String
    }

    public struct Invocation_performRequest {
        let request: URLRequest
        let reportId: String
        let includeLogs: Bool
        let onSuccess: Void
        let onPermanentFailure: Void
    }

    private(set) var stubbed_performRequest: Stub_performRequest?
    private(set) var invocations_performRequest: Invocations_PerformRequest = Invocations_PerformRequest()

    @objc
    public func performRequest(
        request: URLRequest,
        reportId: String,
        includeLogs: Bool,
        onSuccess: @escaping () -> Void,
        onPermanentFailure: @escaping (Error, String) -> Void
    ) -> String {
        guard let stub = stubbed_performRequest else {
            fatalError("Unexpected invocation of unstubbed method")
        }

        if stub.request.predicate(request) &&
            stub.reportId.predicate(reportId) &&
            stub.includeLogs.predicate(includeLogs) {
            
            let invocation = Invocation_performRequest(
                request: request,
                reportId: reportId,
                includeLogs: includeLogs,
                onSuccess: (),
                onPermanentFailure: ()
            )
            invocations_performRequest.invocations.append(invocation)

            if let _ = stub.onSuccess {
                onSuccess()
            }

            if let invoke_onPermanentFailure = stub.onPermanentFailure {
                onPermanentFailure(invoke_onPermanentFailure.param1, invoke_onPermanentFailure.param2)
            }
        }
        return stub.returnValue
    }
}

