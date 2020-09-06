//
//  Core.swift
//  LTXiOSUtils
//  系统扩展命名空间，对系统类进行扩展，用来替换OC中前缀的做法，更Swift的做法
//  Created by 李天星 on 2020/1/12.
//

import Foundation

/// 核心作用域
public struct TxExtensionWrapper<Base> {
    /// 泛型
    public let base: Base

    /// 构造函数
    /// - Parameter base: 泛型
    public init(_ base: Base ) {
        self.base = base
    }
}

/// 协议
public protocol TxExtensionWrapperProtocol {

    /*
     需要使用associatedtype关键字的原因是因为core的类型不固定
     associatedtype是protocol实现泛型的方式
     */

    /// 实例方法关联
    associatedtype CompatibleInstanceType
    /// 类方法关联
    associatedtype CompatibleClassType

    /// 实例方法，只读计算属性
    var tx: CompatibleInstanceType { get set }
    /// 类方法，只读计算属性
    static var tx: CompatibleClassType { get set }
}
/// Compatible协议默认实现
extension TxExtensionWrapperProtocol {
    /// 实例方法默认实现
    public var tx: TxExtensionWrapper<Self> {
        get {
            return TxExtensionWrapper(self)
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // 提供set方法使关联的实例可以进行修改
        }
    }

    /// 类方法默认实现
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
