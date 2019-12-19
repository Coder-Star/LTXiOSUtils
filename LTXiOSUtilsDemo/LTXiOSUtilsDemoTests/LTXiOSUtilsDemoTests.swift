//
//  LTXiOSUtilsDemoTests.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2019/8/2.
//  Copyright © 2019年 李天星. All rights reserved.
//

import XCTest
import LTXiOSUtils
import QorumLogs
@testable import LTXiOSUtilsDemo

class LTXiOSUtilsDemoTests: XCTestCase {

    override func setUp() {

    }

    override func tearDown() {

    }

    func testExample() {
        QL1(Date().weekDay)

    }

    func testPerformanceExample() {

        self.measure {

        }
    }

}
