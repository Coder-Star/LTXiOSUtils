//
//  Debouncer.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/8/3.
//

import Foundation

/// 防抖
/// n 秒后在执行该事件，若在 n 秒内被重复触发，则重新计时
/// 应用场景1、处理搜索框过于频繁发起网络请求的问题，每当用户输入一个字符的时候，都发起网络请求，会浪费一部分网络资源，通过debounce，可以实现，当用户停止输入0.5秒再发送请求。
/// 应用场景2、处理按钮的连续点击问题，debounce只接收0.5秒后的最后一次点击事件，因此自动忽略了中间的多次连续点击事件
public class Debouncer {
    private let queue: DispatchQueue
    private let interval: TimeInterval

    private let semaphore: DebouncerSemaphore
    private var workItem: DispatchWorkItem?

    public init(seconds: TimeInterval = 0.5, queue: DispatchQueue = .main) {
        interval = seconds
        semaphore = DebouncerSemaphore(value: 1)
        self.queue = queue
    }

    public func invoke(_ action: @escaping (() -> Void)) {
        semaphore.sync {
            workItem?.cancel()
            workItem = DispatchWorkItem(block: {
                action()
            })
            if let item = workItem {
                queue.asyncAfter(deadline: .now() + self.interval, execute: item)
            }
        }
    }
}

/// 节流
/// n 秒内只运行一次，若在 n 秒内重复触发，只有一次生效
/// 应用场景1：监听页面滚动进行相关操作
public class Throttler {
    private let queue: DispatchQueue
    private let interval: TimeInterval

    private let semaphore: DebouncerSemaphore
    private var workItem: DispatchWorkItem?
    private var lastExecuteTime = Date()

    public init(seconds: TimeInterval = 0.5, queue: DispatchQueue = .main) {
        interval = seconds
        semaphore = DebouncerSemaphore(value: 1)
        self.queue = queue
    }

    public func invoke(_ action: @escaping (() -> Void)) {
        semaphore.sync {
            workItem?.cancel()
            workItem = DispatchWorkItem(block: { [weak self] in
                self?.lastExecuteTime = Date()
                action()
            })
            let deadline = Date().timeIntervalSince(lastExecuteTime) > interval ? 0 : interval
            if let item = workItem {
                queue.asyncAfter(deadline: .now() + deadline, execute: item)
            }
        }
    }
}

private struct DebouncerSemaphore {
    private let semaphore: DispatchSemaphore

    fileprivate init(value: Int) {
        semaphore = DispatchSemaphore(value: value)
    }

    fileprivate func sync(execute: () -> Void) {
        defer { semaphore.signal() }
        semaphore.wait()
        execute()
    }
}
