//
//  AsyncOperation.swift
//  LTXiOSUtils
//  异步处理Operation
//  Created by CoderStar on 2021/8/30.
//

import Foundation

public class AsyncOperation: Operation {
    private var block: ((_ operation: AsyncOperation) -> Void)?

    private let queue = DispatchQueue(label: "async.operation.queue")
    private let lock = NSLock()

    private var _executing = false
    private var _finished = false

    /// 数据
    ///
    /// 为Operation绑定一下数据，方便被依赖的Operation获取该Operation处理后的一些数据
    public var data: Any?

    /// 是否执行
    ///
    /// 内部加锁保证线程安全
    public override var isExecuting: Bool {
        get {
            lock.lock()
            let wasExecuting = _executing
            lock.unlock()
            return wasExecuting
        }
        set {
            if isExecuting != newValue {
                willChangeValue(forKey: "isExecuting")
                lock.lock()
                _executing = newValue
                lock.unlock()
                didChangeValue(forKey: "isExecuting")
            }
        }
    }

    /// 是否结束
    ///
    /// 内部加锁保证线程安全
    /// 需要手动进行KVO，否则completionBlock不会被触发，被依赖的Operation也不会开始
    public override var isFinished: Bool {
        get {
            lock.lock()
            let wasFinished = _finished
            lock.unlock()
            return wasFinished
        }
        set {
            if isFinished != newValue {
                willChangeValue(forKey: "isFinished")
                lock.lock()
                _finished = newValue
                lock.unlock()
                didChangeValue(forKey: "isFinished")
            }
        }
    }

    /// 标识该Operation是否以异步形式运行
    public override var isAsynchronous: Bool {
        return true
    }

    public override func start() {
        if isCancelled {
            isFinished = true
            return
        }

        isExecuting = true

        queue.async { [weak self] in
            self?.main()
        }
    }

    public override func main() {
        if let block = block {
            block(self)
        } else {
            finish()
        }
    }
}

// MARK: - 公开方法

extension AsyncOperation {
    /// 创建AsyncOperation
    /// - Parameter block: 执行闭包，在main方法内部执行，如果传入为nil，则自动结束，如果不为nil，则由自己调用`finish()`手动结束
    public convenience init(block: ((_ operation: AsyncOperation) -> Void)?) {
        self.init()
        self.block = block
    }

    /// 手动
    public func finish() {
        isExecuting = false
        isFinished = true
    }
}
