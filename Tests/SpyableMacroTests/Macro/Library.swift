// Copyright © 2023 Snap, Inc. All rights reserved.

import Foundation

public struct InvokeBlock {
    public init(
    ) {
    }
}

public struct InvokeBlock1<P1> {
    let param1: P1

    public init(
        _ param1: P1
    ) {
        self.param1 = param1
    }
}

@available(iOS 17.0.0, *)
public struct InvokeBlockGeneric<each P> {
    let params: (repeat each P)

    public init(params: (repeat each P)) {
        self.params = params
    }
}

public struct InvokeBlock2<P1, P2> {
    let param1: P1
    let param2: P2

    public init(
        _ param1: P1,
        _ param2: P2
    ) {
        self.param1 = param1
        self.param2 = param2
    }
}

public struct Matching<Param> {
    let predicate: (Param) -> Bool

    init(_ predicate: @escaping (Param) -> Bool) {
        self.predicate = predicate
    }

    static func satisfies(_ predicate: @escaping (Param) -> Bool) -> Matching {
        Matching(predicate)
    }
}

extension Matching where Param: Equatable {
    static func eq(_ otherParam: Param) -> Matching {
        Matching { $0 == otherParam }
    }
}

extension Matching {
    static func any() -> Matching {
        Matching { _ in true }
    }
}
