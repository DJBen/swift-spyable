// Copyright © 2023 Snap, Inc. All rights reserved.

import Foundation

@attached(peer, names: suffixed(Mock))
public macro GenerateTestMock() = #externalMacro(
    module: "SpyableMacro",
    type: "GenerateTestMockMacro"
)

@attached(peer, names: prefixed(stub_), prefixed(expect_), prefixed(verify_))
public macro mockMethod() = #externalMacro(
    module: "SpyableMacro",
    type: "MockMethodMacro"
)

@freestanding(declaration, names: arbitrary)
public macro generateTestMock(_ protocolDecl: String) = #externalMacro(
    module: "SpyableMacro",
    type: "FreeMacro"
)

