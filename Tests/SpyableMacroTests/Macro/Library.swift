// Copyright © 2023 Snap, Inc. All rights reserved.

import Foundation
import XCTest

@available(iOS 17.0.0, *)
public struct InvokeBlockGeneric<each P> {
    let params: (repeat each P)

    public init(params: (repeat each P)) {
        self.params = params
    }
}

public struct InvokeBlock: Equatable {
    public init(
    ) {
    }
}

public struct InvokeBlock1<P1>: Equatable {
    let param1: P1

    public init(
        _ param1: P1
    ) {
        self.param1 = param1
    }

    public static func ==(lhs: InvokeBlock1, rhs: InvokeBlock1) -> Bool {
        return true
    }
}

public struct InvokeBlock2<P1, P2>: Equatable {
    let param1: P1
    let param2: P2

    public init(
        _ param1: P1,
        _ param2: P2
    ) {
        self.param1 = param1
        self.param2 = param2
    }

    public static func ==(lhs: InvokeBlock2, rhs: InvokeBlock2) -> Bool {
        return true
    }
}

public struct Expectation {
    public enum CallCountPredicate: Equatable, ExpressibleByIntegerLiteral {
        case any
        case exact(Int)
        case gt(Int)
        case gte(Int)
        case lt(Int)
        case lte(Int)
        case range(ClosedRange<Int>)

        public init(integerLiteral value: Int) {
            self = .exact(value)
        }

        func matches(_ callCount: Int) -> Bool {
            switch self {
            case .any:
                return true
            case .exact(let count):
                return callCount == count
            case .gt(let count):
                return callCount > count
            case .gte(let count):
                return callCount >= count
            case .lt(let count):
                return callCount < count
            case .lte(let count):
                return callCount <= count
            case .range(let range):
                return range.contains(callCount)
            }
        }

        func verify(methodSignature: String, callCount: Int) {
            if !matches(callCount) {
                let message = violationDescription(
                    methodSignature: methodSignature,
                    actualCall: callCount
                )
                XCTFail(message)
            }
        }

        private func violationDescription(methodSignature: String, actualCall: Int) -> String {
            switch self {
            case .any:
                return "Any number of calls are expected, but \(actualCall) calls are made for \(methodSignature)."
            case .exact(let count):
                return "Exactly \(count) calls are expected, but \(actualCall) calls are made for \(methodSignature)."
            case .gt(let count):
                return "More than \(count) calls are expected, but \(actualCall) calls are made for \(methodSignature)."
            case .gte(let count):
                return "\(count) or more calls are expected, but \(actualCall) calls are made for \(methodSignature)."
            case .lt(let count):
                return "Less than \(count) calls are expected, but \(actualCall) calls are made for \(methodSignature)."
            case .lte(let count):
                return "\(count) or fewer calls are expected, but \(actualCall) calls are made for \(methodSignature)."
            case .range(let range):
                return "Between \(range.lowerBound) and \(range.upperBound) calls are expected, but \(actualCall) calls are made for \(methodSignature)."
            }
        }
    }

    let callCountPredicate: CallCountPredicate

    public static func count(_ predicate: CallCountPredicate) -> Expectation {
        Expectation(callCountPredicate: predicate)
    }
 }
