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

    func test() {
        thread = Thread(block: {
            for (index, item) in self.list.enumerated() {
                print(self.thread)
                print(item)
            }
        })
        thread?.name = "线程"
        thread?.start()
        Thread.sleep(forTimeInterval: 1)
//        thread?.cancel()
    }
}

class MyThread: Thread {

}
