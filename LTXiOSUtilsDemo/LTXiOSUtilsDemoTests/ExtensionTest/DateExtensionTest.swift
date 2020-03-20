//
//  DateExtensionTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2019/8/2.
//  Copyright © 2019年 李天星. All rights reserved.
//

import XCTest
import LTXiOSUtils

@testable import LTXiOSUtils

class DateExtensionTest: XCTestCase {

    func testDateExtension() {
        Log.d("2019-01-01 10:00:00".getDateStr(dateType: .YMDHMS))
        Log.d("2019-01-01 10:00:00".getDateStr(dateType: .YMDHM))
        Log.d("2019-01-01 10:00:00".getDateStr(dateType: .MDHM))
        Log.d("2019-01-01 10:00:00".getDateStr(dateType: .YMD))
        Log.d("2019-01-01 10:00:00".getDateStr(dateType: .HMS))
        Log.d("2019-01-01 10:00:00".getDateStr(dateType: .YM))
        Log.d("2019-01-01 10:00:00".getDateStr(dateType: .MD))
        Log.d("2019-01-01 10:00:00".getDateStr(dateType: .HM))
    }
}
