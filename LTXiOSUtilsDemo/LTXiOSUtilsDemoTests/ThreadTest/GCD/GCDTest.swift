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
}

