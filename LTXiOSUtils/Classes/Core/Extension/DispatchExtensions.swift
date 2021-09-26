//
//  DispatchExtensions.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2019/12/16.
//

import Foundation

extension TxExtensionWrapper where Base: DispatchQueue {
    /// 延时扩展
    ///
    /// - Parameters:
    ///   - delay: 延时时间
    ///   - execute: 闭包执行
    public func delay(_ delay: Double, execute: @escaping () -> Void) {
        base.asyncAfter(deadline: DispatchTime(floatLiteral: delay), execute: execute)
    }

    /// 切换队列
    ///
    /// 当当前线程为主线程并且是主队列切换时，不再进行切换，而是直接执行代码块
    /// - Note: 主线程可以执行非主队列的任务（如主线程中调用全局队列的同步函数）
    /// 避免当主线程执行非主队列任务时，主线程切换队列的开销
    /// 同时避免切换队列造成的执行时序问题
    /// - Parameter block: 代码块
    public func safeAsync(_ block: @escaping () -> Void) {
        if base === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            base.async { block() }
        }
    }
}

extension TxExtensionWrapper where Base == DispatchQueue {
    private static var onceTracker = Set<String>()

    /// 保证代码块只执行一次
    ///
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

