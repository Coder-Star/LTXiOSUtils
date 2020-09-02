//
//  CustomStringConvertibleProtocolTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/9/1.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import XCTest
import LTXiOSUtils


struct UserStruct {
    var name = "张三"
    var age  = 11
}

class UserClass {
    var name = "张三"
    var age  = 11
}

extension UserClass: CustomStringConvertible {
    var description: String {
        return "description:name=\(name),age=\(age)"
    }
}

extension UserClass: CustomDebugStringConvertible {
    var debugDescription: String {
        return "debugDescription:name=\(name),age=\(age)"
    }
}

class CustomStringConvertibleProtocolTest: XCTestCase {

    func testDescription() {
        // 输入结果为 UserStruct(name: "张三", age: 11)
        print(UserStruct())

        // 如果不实现CustomStringConvertible协议，则输出LTXiOSUtilsDemoTests.UserClass
        // 实现CustomStringConvertible协议，则输出description返回的内容
        print(UserClass())

        // 如果不实现CustomDebugStringConvertible、CustomStringConvertible协议，则输出LTXiOSUtilsDemoTests.UserClass
        // 实现CustomDebugStringConvertible协议，则输出debugDescription返回的内容（优先级更高）
        // 实现了CustomStringConvertible协议，输出description返回的内容
        // 这里输出的内容与debugger时控制台通过po命令查看变量输出的内容一致
        debugPrint(UserClass())
    }
}
