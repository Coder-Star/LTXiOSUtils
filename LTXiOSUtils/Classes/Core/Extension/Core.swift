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
}

/// 协议
public protocol CoreCompatible {
    /// 实例方法关联
    associatedtype CoreCompatibleInstanceType
    /// 类方法关联
    associatedtype CoreCompatibleClassType

    /// 实例方法，只读计算属性
    var core: CoreCompatibleInstanceType { get set }
    /// 类方法，只读计算属性
    static var core: CoreCompatibleClassType { get set }
}
/// Compatible协议默认实现
extension CoreCompatible {
    /// 实例方法默认实现
    public var core: Core<Self> {
        get {
            return Core(self)
        }
        // swiftlint:disable unused_setter_value
        set {

        }
        // swiftlint:enable unused_setter_value
    }

    /// 类方法默认实现
    public static var core: Core<Self>.Type {
        get {
            return Core<Self>.self
        }
        // swiftlint:disable unused_setter_value
        set {

        }
        // swiftlint:enable unused_setter_value
    }
}

extension NSObject: CoreCompatible {}

//extension String: CoreCompatible {}
//extension Double: CoreCompatible {}
//extension Array: CoreCompatible {}
//extension Int: CoreCompatible {}
//extension Date: CoreCompatible {}
