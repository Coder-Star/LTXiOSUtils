//
//  DispatchExtensions.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/12/16.
//

import Foundation

extension TxExtensionWrapper where Base: DispatchQueue {

    /// 延时扩展
    ///
    /// - Parameters:
    ///   - delay: 延时时间
    ///   - execute: 闭包执行
    public func delay(_ delay: Double, execute: @escaping () -> Void) {
        base.asyncAfter(deadline: DispatchTime.init(floatLiteral: delay), execute: execute)
    }
}

extension TxExtensionWrapper where Base == DispatchQueue {
    private static var onceTracker = Set<String>()

    /// 类似一个单例模式，保证只执行一次
    /// - Parameters:
    ///   - token: 唯一标识符
    ///   - block: 闭包
    public static func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if onceTracker.contains(token) {
            return
        }
        onceTracker.insert(token)
        block()
    }
}

// MARK: - DispatchTime扩展，构造函数
extension DispatchTime: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {

    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }

    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1_000))
    }
}
