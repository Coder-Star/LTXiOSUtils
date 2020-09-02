//
//  ExpressibleProtocolTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/9/1.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import XCTest
import LTXiOSUtils

struct Money {
    var value: String

    init(value: String) {
        self.value = value
    }
}

extension Money: ExpressibleByBooleanLiteral {
    typealias BooleanLiteralType = Bool
    init(booleanLiteral value: Bool) {
        self.value = value ? "是" : "否"
    }
}

class ExpressibleProtocolTest: XCTestCase {

    func test() {
        let money = false
        let expressMoney: Money = false

        Log.d(money)
        Log.d(expressMoney.value)
    }
}
