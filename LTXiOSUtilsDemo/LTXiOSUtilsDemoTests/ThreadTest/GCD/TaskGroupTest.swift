//
//  TaskGroupTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/9/27.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import XCTest
import LTXiOSUtils

/**
 多个任务执行完毕之后再执行某个任务
 */

class TaskGroupTest: XCTestCase {

    /**
     使用DispatchGroup
     group.enter() 将任务加入任务组，group.leave() 将任务移除任务组，当任务组里面任务为0时，会触发notify
     当任务数大于0时，将永远不会触发notify；当任务数小于0时，会出现错误，产生Crash
     */
    func testDispatchGroup() {
        let expectationInfo = expectation(description: "thread")

        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            Log.d("第一个任务完成")
            group.leave()
        }

        group.enter()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            Log.d("第二个任务完成")
            group.leave()
        }

        // 该操作为异步
        group.notify(queue: .main) {
            Log.d("任务全部完成")

            expectationInfo.fulfill()
        }

        Log.d("正常运行")

        // 该方法会阻塞当前线程，在所有任务完成之后再执行当前线程中后续的代码，后续代码先于 notify 运行
        group.wait()

        Log.d("group.wait()后的运行")

        _ = XCTWaiter(delegate: self).wait(for: [expectationInfo], timeout:  5)
    }


    func testbBarrierDispatchWorkItem() {
        let expectationInfo = expectation(description: "thread")
        let queue = DispatchQueue(label: "􏴉􏱧􏱢􏱧􏱢􏲼􏱛􏱭􏱢􏴉􏱧􏱢􏱧􏱢􏲼􏱛􏱭􏱢queueName", attributes: [.concurrent])
        queue.async {
            Thread.sleep(forTimeInterval: 2)
            Log.d("第一个任务完成")
        }


        queue.async {
            Thread.sleep(forTimeInterval: 1)
            Log.d("第二个任务完成")
        }


        let barrierTask = DispatchWorkItem(flags: .barrier) {

        }

        /**
         栅栏任务会对  当前队列的任务 进行阻隔，会等待队列中已有的任务全部执行完成，然后再执行
         在它之后的加入的任务也必须等到栅栏任务执行完毕之后才能执行

         */
        // 面对栅栏任务，使用async异步执行和使用sync同步执行效果一样
        queue.async(execute: barrierTask)

        queue.async {
            Log.d("任务全部完成")
            expectationInfo.fulfill()
        }

        DispatchQueue.global().async {
            Log.d("栅栏函数后另开线程的运行")
        }

        _ = XCTWaiter(delegate: self).wait(for: [expectationInfo], timeout:  5)
    }

    func testSemaphore() {
        let expectationInfo = expectation(description: "thread")

        let semaphore = DispatchSemaphore(value: 2)
        semaphore.wait()
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            Log.d("第一个任务完成")
            semaphore.signal()
        }

        semaphore.wait()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            Log.d("第二个任务完成")
            semaphore.signal()
        }
        semaphore.wait()
        semaphore.wait()

        DispatchQueue.global().async {
            Log.d("全部任务完成")
            expectationInfo.fulfill()
        }

        _ = XCTWaiter(delegate: self).wait(for: [expectationInfo], timeout:  5)
    }

}
