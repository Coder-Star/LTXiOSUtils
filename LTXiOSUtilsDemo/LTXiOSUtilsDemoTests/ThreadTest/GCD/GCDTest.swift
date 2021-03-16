//
//  GCDTest.swift
//  LTXiOSUtilsDemoTests
//  
//  Created by 李天星 on 2020/8/26.
//  Copyright © 2020 李天星. All rights reserved.
//

import XCTest
import LTXiOSUtils

@testable import LTXiOSUtils

class GCDTest: XCTestCase {

    let list = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]

    /**
     使用Lock以及信号量保证串行运行
     */
    func testDemo() {
        let lockA = NSLock()
        let lockB = NSLock()
        let lockC = NSLock()

        lockB.lock()
        lockC.lock()
        DispatchQueue.global().async {
            for item in self.list {
                lockA.lock()
                print("A:\(item)")
                lockB.unlock()
            }
        }
        DispatchQueue.global().async {
            for item in self.list {
                // 因为已经对lockB进行加锁，所以在这加锁失败，导致该线程一直阻塞，不会加载加锁后面的代码，会一直等待加锁成功后进行执行
                lockB.lock()
                print("B:\(item)")
                lockC.unlock()
            }
        }
        DispatchQueue.global().async {
            for item in self.list {
                lockC.lock()
                print("C:\(item)")
                lockA.unlock()
            }
        }
    }

    func testDemo1() {
        let semaphoreA = DispatchSemaphore(value: 1)
        let semaphoreB = DispatchSemaphore(value: 0)
        let semaphoreC = DispatchSemaphore(value: 0)

        DispatchQueue.global().async {
            for item in self.list {
                semaphoreA.wait()
                print("A:\(item)")
                semaphoreB.signal()
            }
        }
        DispatchQueue.global().async {
            for item in self.list {
                // 信号量为0，导致该处线程阻塞
                semaphoreB.wait()
                print("B:\(item)")
                semaphoreC.signal()
            }
        }
        DispatchQueue.global().async {
            for item in self.list {
                semaphoreC.wait()
                print("C:\(item)")
                semaphoreA.signal()
            }
        }
    }

    /**
     将还未完成的WorkItem取消
     */
    func testDemo2() {

        let expectationInfo = expectation(description: "thread")

        let workItem = DispatchWorkItem {
            Log.d("任务开始")
            expectationInfo.fulfill()
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: workItem)

        DispatchQueue.global().asyncAfter(deadline: .now() + 2.01) {
            workItem.cancel()
        }

        _ = XCTWaiter(delegate: self).wait(for: [expectationInfo], timeout:  5)
    }


    /// 串行队列
    func testDemo3() {
        let serialQueue = DispatchQueue(label: "serialQueue",qos: .userInteractive)
        
        serialQueue.sync {
            Log.d("串行队列同步任务")
        }

        serialQueue.async {
            Log.d("串行队列异步任务1-1")
            Log.d("串行队列异步任务1-2")
        }

        serialQueue.async {
            Log.d("串行队列异步任务2-1")
            Log.d("串行队列异步任务2-2")
        }

        Log.d("函数结束")

        /**
         串行队列同步任务
         函数结束
         串行队列异步任务1-1
         串行队列异步任务1-2
         串行队列异步任务2-1
         串行队列异步任务2-2
         */
    }

    /// 并行队列
    func testDemo4() {
        let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)

        concurrentQueue.sync {
            Log.d("并行队列同步任务")
        }

        concurrentQueue.async {
            Log.d("并行队列异步任务1-1")
            Log.d("并行队列异步任务1-2")
        }

        concurrentQueue.async {
            Log.d("并行队列异步任务2-1")
            Log.d("并行队列异步任务2-2")
        }
        Log.d("函数结束")
        /**

         */
    }

    /**
     引发死锁，死锁原因是sync方法会立刻阻塞主线程，函数不再向下进行，但是主线程当前正在运行函数，需要函数运行完毕之后才可以同步任务，两者互相等待，导致死锁
     */
    func testDemo5() {
        DispatchQueue.main.sync {
            Log.d("main")
        }
        Log.d("函数结束")
    }

    /**
     主队列不会开启新的线程，会把已经添完的任务执行完毕执行 异步任务
     */
    func testDemo6() {
        DispatchQueue.main.async {
            Log.d("main")
        }
        Log.d("函数结束")
    }
}

