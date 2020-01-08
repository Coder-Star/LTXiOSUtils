//
//  DateExtensionTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2019/8/2.
//  Copyright © 2019年 李天星. All rights reserved.
//

import XCTest
import LTXiOSUtils
import QorumLogs

@testable import LTXiOSUtils

class DateExtensionTest: XCTestCase {

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
}
