// Copyright © 2023 Snap, Inc. All rights reserved.

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

enum TestCases {
    enum Case1 {
        static let protocolDecl = try! ProtocolDeclSyntax(
        #"""
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
        """#
        )

        static let functionDecl = try! FunctionDeclSyntax(
            #"""
            @objc
            func performRequest(
                request: URLRequest,
                reportId: String,
                includeLogs: Bool,
                onSuccess: @escaping () -> Void,
                onPermanentFailure: @escaping (Error, String) -> Void
            ) -> String
            """#
        )
    }
}
