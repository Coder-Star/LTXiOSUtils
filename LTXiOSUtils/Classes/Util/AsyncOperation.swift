//
//  AsyncOperation.swift
//  LTXiOSUtils
//
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

    private var asyncFinished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }

    private var block: ((_ operation: AsyncOperation) -> Void)?

    override func start() {
        if isCancelled {
            asyncFinished = true
            return
        }
        asyncExecuting = true
        block?(self)
    }

    public convenience init(block: ((_ operation: AsyncOperation) -> Void)?) {
        self.init()
        self.block = block
    }

    public func finish() {
        asyncExecuting = false
        asyncFinished = true
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
