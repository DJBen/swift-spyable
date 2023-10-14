// Copyright © 2023 Snap, Inc. All rights reserved.

import XCTest

class TestContainer {
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
        let container = TestContainer(executor: mock)
        let expectation = expectation(description: "")

        mock.stub_performRequest(
            request: .satisfies {
                $0.url == URL(string: "https://test.com/123")!
            },
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
        XCTAssertEqual(mock.invocations_performRequest.invocations.count, 1)
    }

    func test_failure() throws {
        let mock = SCCrashLoggerNetworkExecutorMock()
        let container = TestContainer(executor: mock)
        let expectation2 = expectation(description: "")

        mock.stub_performRequest(
            request: .satisfies {
                $0.url == URL(string: "https://test.com/345")!
            },
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
        XCTAssertEqual(mock.invocations_performRequest.invocations.count, 1)
    }
}
