//
//  EnumTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/9/3.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import XCTest
import LTXiOSUtils

enum Direction: String {
    case top = "上"
    case bottom = "下"
    case left = "左"
    case right = "右"
}

// CaseIterable协议提供了allCases方法用来获取枚举所有选项
extension Direction: CaseIterable {

}

class EnumTest: XCTestCase {

    func test() {
        for item in Direction.allCases {
            Log.d(item)
        }
    }

}
