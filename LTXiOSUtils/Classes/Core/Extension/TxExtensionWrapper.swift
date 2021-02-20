//
//  TxExtensionWrapper.swift
//  LTXiOSUtils
//  系统扩展命名空间，对系统类进行扩展，用来替换OC中前缀的做法，更Swift的做法
//  Created by 李天星 on 2020/1/12.
//

import Foundation

/// 扩展命名空间
public struct TxExtensionWrapper<Base> {
    /// 泛型
    public let base: Base

    /// 构造函数
    /// - Parameter base: 泛型
    public init(_ base: Base ) {
        self.base = base
    }
}

/// 引用类型协议
public protocol TxExtensionWrapperCompatible: AnyObject { }

/// 值类型协议
public protocol TxExtensionWrapperCompatibleValue { }

/// TxExtensionWrapperCompatible协议默认实现
extension TxExtensionWrapperCompatible {
    /// 实例变量
    public var tx: TxExtensionWrapper<Self> {
        get {
            return TxExtensionWrapper(self)
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // 提供set方法使关联的实例可以进行修改
        }
    }

    /// 类变量
    public static var tx: TxExtensionWrapper<Self>.Type {
        get {
            return TxExtensionWrapper<Self>.self
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // 提供set方法使关联的类可以进行修改
        }
    }
}

/// TxExtensionWrapperCompatibleValue协议默认实现
extension TxExtensionWrapperCompatibleValue {
    /// 实例变量
    public var tx: TxExtensionWrapper<Self> {
        get {
            return TxExtensionWrapper(self)
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // 提供set方法使关联的实例可以进行修改
        }
    }

    /// 类变量
    public static var tx: TxExtensionWrapper<Self>.Type {
        get {
            return TxExtensionWrapper<Self>.self
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // 提供set方法使关联的类可以进行修改
        }
    }
}
