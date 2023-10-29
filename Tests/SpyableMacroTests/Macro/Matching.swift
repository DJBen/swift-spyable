// Copyright © 2023 Snap, Inc. All rights reserved.

import Foundation

public struct Matching<Param> {
    let predicate: (Param) -> Bool
    let description: String

    public init(_ predicate: @escaping (Param) -> Bool, description: String? = nil) {
        self.predicate = predicate
        self.description = description ?? "<predicate>"
    }

    public func matches(_ value: Param) -> Bool {
        predicate(value)
    }
}

extension Matching {
    public static func any() -> Matching {
        Matching({ _ in true }, description: "<any>")
    }
}

extension Matching where Param: Equatable {
    public static func eq(_ otherParam: Param) -> Matching {
        Matching({ $0 == otherParam }, description: "==\(otherParam)")
    }
}

extension Matching where Param == URLRequest {
    public static func url(_ url: URL) -> Matching {
        Matching({ $0.url == url }, description: "==\(url)")
    }
}
