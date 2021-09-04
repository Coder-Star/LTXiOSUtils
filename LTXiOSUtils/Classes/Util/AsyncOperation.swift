//
//  AsyncOperation.swift
//  LTXiOSUtils
//  异步处理Operation
//  Created by CoderStar on 2021/8/30.
//

import Foundation

class AsyncOperation: Operation {
    private var asyncExecuting = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }

    /// 内部控制Operation是否结束变量
    ///
    /// 需要手动进行KVO，否则completionBlock不会被触发，被依赖的Operation也不会开始
    private var asyncFinished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }


    private var block: ((_ operation: AsyncOperation) -> Void)?

    /// 数据
    ///
    /// 为Operation绑定一下数据，方便被依赖的Operation获取该Operation处理后的一些数据
    public var data: Any?

    override func start() {
        if isCancelled {
            asyncFinished = true
            return
        }
        asyncExecuting = true
        block?(self)
    }

    override var isAsynchronous: Bool {
        return true
    }

    override var isConcurrent: Bool {
        return true
    }

    override var isFinished: Bool {
        return asyncFinished
    }

    override var isExecuting: Bool {
        return asyncExecuting
    }
}

// MARK: - 公开方法

extension AsyncOperation {
    public convenience init(block: ((_ operation: AsyncOperation) -> Void)?) {
        self.init()
        self.block = block
    }

    public func finish() {
        asyncExecuting = false
        asyncFinished = true
    }
}
