//
//  Core.swift
//  LTXiOSUtils
//  核心作用域
//  Created by 李天星 on 2020/1/12.
//

import Foundation

public struct Core<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
    public var build: Base {
        return base
    }
}

public protocol Compatible {
    associatedtype CompatibleType
    var core: CompatibleType { get }
}
extension Compatible {
    public var core: Core<Self> {
        return Core(self)
    }
}

extension NSObject: Compatible {}
