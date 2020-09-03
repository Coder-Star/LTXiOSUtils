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

// 定义协议，方便遍历枚举
protocol EnumeratableEnumType {
    static var allCases: [Self] {get}
}

enum Direction: String, EnumeratableEnumType {
    case top = "上"
    case bottom = "下"
    case left = "左"
    case right = "右"

    static var allCases: [Direction] {
        return [.top, .bottom, .left, .right]
    }
}

class EnumTest: XCTestCase {

    func test() {
        for item in Direction.allCases {
            Log.d(item)
        }
    }

}
