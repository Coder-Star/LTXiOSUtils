//
//  SwiftTest.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/7/9.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

class SwiftTest {

    class func setup() {
        testSet()
    }

    /// 测试Set
    class func testSet() {
        var set = Set<String>()
        set.insert("1")
        set.insert("2")
        Log.d(set.insert("3")) // (inserted: true, memberAfterInsert: "3")
        Log.d(set.insert("1")) // (inserted: false, memberAfterInsert: "1")

        let a: AnyObject = SwiftTest()
        Log.d(a)
    }
}
