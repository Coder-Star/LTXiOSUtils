//
//  DispatchQueueExtensions.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/12/16.
//

import Foundation

extension DispatchQueue {
    /// 延时扩展
    ///
    /// - Parameters:
    ///   - delay: 延时时间
    ///   - execute: 闭包执行
    public func delay(_ delay: Double, execute: @escaping () -> Void) {
        asyncAfter(deadline: DispatchTime.init(floatLiteral: delay), execute: execute)
    }
}

extension DispatchQueue {
    private static var _onceTracker = [String]()

    /// 类似一个单例模式，保证只执行一次
    /// - Parameters:
    ///   - token: 唯一标识符
    ///   - block: 闭包
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
