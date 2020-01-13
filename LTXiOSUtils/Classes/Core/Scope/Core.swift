//
//  Core.swift
//  LTXiOSUtils
//  核心作用域
//  Created by 李天星 on 2020/1/12.
//

import Foundation

/// 核心作用域
public struct Core<Base> {
    /// 泛型
    public let base: Base
    /// 构造函数
    /// - Parameter base: 泛型
    public init(_ base: Base) {
        self.base = base
    }
    /// 生成
    public var build: Base {
        return base
    }
}

/// 协议
public protocol Compatible {
    /// 关联
    associatedtype CompatibleType
    /// 生成核心
    var core: CompatibleType { get }
}
extension Compatible {
    /// 生成核心实现
    public var core: Core<Self> {
        return Core(self)
    }
}

extension NSObject: Compatible {}
