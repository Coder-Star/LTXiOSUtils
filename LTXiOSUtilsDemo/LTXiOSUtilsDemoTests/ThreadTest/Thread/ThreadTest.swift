//
//  ThreadTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/8/27.
//  Copyright © 2020 李天星. All rights reserved.
//

import XCTest
import LTXiOSUtils

@testable import LTXiOSUtils

class ThreadTest: XCTestCase {

    let list = [1,2,3,4]

    var thread: Thread?
    let condition = NSCondition()

    func test() {
        thread = Thread {
            for item in self.list {
                Log.d(item)
            }
        }
        thread?.name = "线程"
        thread?.start()

        CFRunLoopStop(CFRunLoopGetCurrent())
    }

    // 自定义线程
    func test1() {
        // Thread子类重写main方法，执行体变为main()方法里面的内容，不再执行闭包内容
        thread = MyThread()
        thread?.start()
    }

    func test2() {
        Thread.detachNewThread {
            Log.d(1)
        }
    }
}

class MyThread: Thread {
    // 这种重写方法的方式比较适合代码较多，功能较复杂的操作
    override func main() {
        Log.d(Thread.isMainThread)

        // 在非主线程中
        DispatchQueue.main.sync {
            Log.d(Thread.isMainThread) // true
        }
        DispatchQueue.main.async {
            Log.d(Thread.isMainThread) // true
        }
        Log.d("重写main方法的线程")
    }
}
