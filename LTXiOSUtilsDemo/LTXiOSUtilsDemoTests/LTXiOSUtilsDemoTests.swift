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

    func testDateExtension() {
        QL1("2019-01-01 10:00:00".getDateStr(dateType: .YMDHMS))
        QL1("2019-01-01 10:00:00".getDateStr(dateType: .YMDHM))
        QL1("2019-01-01 10:00:00".getDateStr(dateType: .MDHM))
        QL1("2019-01-01 10:00:00".getDateStr(dateType: .YMD))
        QL1("2019-01-01 10:00:00".getDateStr(dateType: .HMS))
        QL1("2019-01-01 10:00:00".getDateStr(dateType: .YM))
        QL1("2019-01-01 10:00:00".getDateStr(dateType: .MD))
        QL1("2019-01-01 10:00:00".getDateStr(dateType: .HM))
    }

    func testArrayExtension() {
        let arr = [1,1,2,3,4,4,5,5]
        let list = [["1":"张三"],["1":"张三"],["1":"李四"]]
        QL1(arr.removeDuplicate{$0})
        QL1(list.removeDuplicate{$0["1"]})
    }

    func testPerformanceExample() {
        self.measure {
        }
    }

}
