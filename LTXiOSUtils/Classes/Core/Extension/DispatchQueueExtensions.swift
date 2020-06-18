//
//  DispatchQueueExtensions.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/12/16.
//

import Foundation

public extension TxExtensionWrapper where Base: DispatchQueue {
    /// 延时扩展
    ///
    /// - Parameters:
    ///   - delay: 延时时间
    ///   - execute: 闭包执行
    func delay(_ delay: Double, execute: @escaping () -> Void) {
        base.asyncAfter(deadline: DispatchTime.init(floatLiteral: delay), execute: execute)
    }
}

public extension TxExtensionWrapper where Base == DispatchQueue {
    private static var onceTracker = [String]()

    /// 类似一个单例模式，保证只执行一次
    /// - Parameters:
    ///   - token: 唯一标识符
    ///   - block: 闭包
    static func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if onceTracker.contains(token) {
            return
        }
        onceTracker.append(token)
        block()
    }
}
