//
//  CopyTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/11/27.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import XCTest
import LTXiOSUtils



class NSUserInfo: NSCopying {
    var name = "张三"
    func copy(with zone: NSZone? = nil) -> Any {
        let user = NSUserInfo.init()
        return user
    }
}

// 深度复制协议
protocol Copyable {
    // self不仅表示协议自身，也包括实现协议的子类
    func copy() -> Self
}

class UserInfo: Copyable {
    var name: String

    func copy() -> Self {
        // 这部分代码要求必须实现 required init
        return type(of: self).init(name: "")
    }

    required init(name: String) {
        self.name = name
    }
}

class CopyTest: XCTestCase {

    func test() {
        let user = UserInfo(name: "李四")
        let user1 = user.copy()

        Log.d("user \(user.name)")
        Log.d("user1 \(user1.name)")
    }

}
