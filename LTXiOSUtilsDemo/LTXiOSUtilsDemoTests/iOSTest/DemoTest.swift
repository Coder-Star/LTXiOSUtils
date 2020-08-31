//
//  DemoTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/4/3.
//  Copyright © 2020 李天星. All rights reserved.
//

import XCTest
import LTXiOSUtils

@testable import LTXiOSUtils

class DemoTest: XCTestCase {

    func testDemo() {
        // 次方运算
        print(pow(2, 2))
        // 位左移，下为2的4次方
        print(1<<4)
        // 四舍五入
        print(lroundf(23.5))
    }
}
