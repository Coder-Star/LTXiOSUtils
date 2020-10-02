//
//  OperationTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/10/2.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import LTXiOSUtils
import XCTest

class OperationTest: XCTestCase {

    func test() {
        /**
         一个operation可以关联多个Block任务，
         */
        let operation = BlockOperation()

        operation.addExecutionBlock {
            Log.d("ExecutionBlock")
            Log.d(Thread.isMainThread)
        }

        // 追加任务
        // 如果操作中的任务数大于1，那么就会开子线程并发执行任务
        // 不一定是子线程，有可能是主线程
        operation.addExecutionBlock {
            Log.d("ExecutionBlock1")
            Log.d(Thread.isMainThread)
        }

        operation.completionBlock = {
            Log.d("operation完成")
        }

        // 单独使用Operation，调用start()方法，默认会在当前线程中运行
        operation.start()
    }


    func test1() {
        let operation1 = BlockOperation {
            for item in 0..<4 {
                Log.d("operation1:\(item)")
            }
            Log.d(Thread.isMainThread)
        }

        let operation2 = BlockOperation {
            for item in 0..<4 {
                Log.d("operation2:\(item)")
            }
            Log.d(Thread.isMainThread)
        }

        let operation3 = BlockOperation {
            for item in 0..<4 {
                Log.d("operation3:\(item)")
            }
            Log.d(Thread.isMainThread)
        }

        // 主队列加入的操作会在 主线程中 串行运行
//        OperationQueue.main.addOperation(operation1)
//        OperationQueue.main.addOperation(operation2)
//        OperationQueue.main.addOperation(operation3)


        // 非主队列，直接创建的队列，同时具有串行以及并行的功能，通过设置最大并发数控制是串行还是并行
        let queue = OperationQueue()

        // 设置最大并发控制数为1，使操作串行运行
        queue.maxConcurrentOperationCount = 1

        // 设置依赖关系需要在加入队列之前设置，如下operation3会在operation1以及operation1都完成的情况下执行
        // 不同操作之间也可以设置依赖
        operation3.addDependency(operation1)
        operation3.addDependency(operation2)

        queue.addOperation(operation1)
        queue.addOperation(operation2)
        queue.addOperation(operation3)
    }

    func test2() {
        let operation = MyOperation()
        operation.start()
    }

}

class MyOperation: Operation {
    override func main() {
        Log.d(Thread.isMainThread)
        Log.d("自定义Operation")
    }
}
