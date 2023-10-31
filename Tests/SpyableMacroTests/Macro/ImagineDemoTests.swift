// Copyright © 2023 Snap, Inc. All rights reserved.

import XCTest

class TestedClass {
    let executor: SCCrashLoggerNetworkExecuting

    init(executor: SCCrashLoggerNetworkExecuting) {
        self.executor = executor
    }

    func run(
        reportId: String,
        onCompletion: @escaping (Error?) -> Void
    ) -> String {
        return executor.performRequest(
            request: URLRequest(url: URL(string: "https://test.com/\(reportId)")!),
            reportId: reportId,
            includeLogs: true,
            onSuccess: {
                print("Success")
                onCompletion(nil)
            },
            onPermanentFailure: { error, str in
                print("Error \(error), String \(str)")
                onCompletion(error)
            }
        )
    }
}

final class ImagineDemo: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_success() throws {
        let mock = SCCrashLoggerNetworkExecutorMock()
        let container = TestedClass(executor: mock)
        let expectation = expectation(description: "")

        mock.stub_performRequest(
            request: Matching(
                {
                    $0.url == URL(string: "https://test.com/123")!
                },
                description: "==\"https://test.com/123\""
            ),
            reportId: .eq("123"),
            includeLogs: .eq(true),
            onSuccess: InvokeBlock(),
            onPermanentFailure: nil,
            andReturn: "identifier"
        )

        XCTAssertEqual(
            container.run(
                reportId: "123",
                onCompletion: { error in
                    XCTAssertNil(error)
                    expectation.fulfill()
                }
            ),
            "identifier"
        )
        mock.verify_performRequest()
        waitForExpectations(timeout: 1)
    }

    func test_failure_unstubbedInvocation() throws {
        let mock = SCCrashLoggerNetworkExecutorMock() // generated
        let container = TestedClass(executor: mock)
        let expectation2 = expectation(description: "")

        mock.stub_performRequest(
            request: Matching(
                {
                    $0.url == URL(string: "https://test.com/123")!
                },
                description: "==\"https://test.com/123\""
            ),
            reportId: .eq("123"),
            includeLogs: .eq(true),
            onSuccess: InvokeBlock(),
            onPermanentFailure: nil,
            andReturn: "identifier"
        )

        XCTAssertEqual(
            container.run(
                reportId: "123",
                onCompletion: { error in
                    XCTAssertNil(error)
                    expectation2.fulfill()
                }
            ), 
            "identifier"
        )
        mock.verify_performRequest()
        waitForExpectations(timeout: 1)
    }

    func test_failure_expectedInvocationCount_shouldFail() throws {
        let mock = SCCrashLoggerNetworkExecutorMock() // generated
        let container = TestedClass(executor: mock)
        let expectation2 = expectation(description: "")

        mock.expect_performRequest(
            request: .url(URL(string: "https://test.com/123")!),
            reportId: .eq("123"),
            includeLogs: .eq(true),
            onSuccess: nil,
            onPermanentFailure: InvokeBlock2(NSError(domain: "aaa", code: 1), "sss"),
            andReturn: "identifier",
            expectation: .count(0)
        )

        XCTAssertEqual(
            container.run(
                reportId: "123",
                onCompletion: { error in
                    XCTAssertNotNil(error)
                    expectation2.fulfill()
                }
            ),
            "identifier"
        )

        mock.verify_performRequest()
        waitForExpectations(timeout: 1)
    }
}
