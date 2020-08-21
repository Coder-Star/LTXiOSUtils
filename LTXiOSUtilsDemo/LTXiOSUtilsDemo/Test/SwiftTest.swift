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
        testFile()
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

    class func testFile() {
        // 沙盒主目录
        let path = NSHomeDirectory()
        // Documtents目录
        let documtentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        // Library目录
        let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
        // Application Support目录，在Library目录下
        let applicationSupportPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!
        // Caches目录，在Library目录下
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        // Preferences目录，在Library目录下
        let preferencesPath = NSSearchPathForDirectoriesInDomains(.preferencePanesDirectory, .userDomainMask, true).first!
        // tmp目录
        let tmpPath = NSTemporaryDirectory()
        Log.d([path, documtentsPath, libraryPath, applicationSupportPath, cachesPath, preferencesPath, tmpPath])
    }
}
