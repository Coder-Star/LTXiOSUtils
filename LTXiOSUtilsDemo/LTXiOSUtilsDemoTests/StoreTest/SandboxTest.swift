//
//  SandboxTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/9/7.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import XCTest
import LTXiOSUtils


class SandboxTest: XCTestCase {

    func test() {
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
