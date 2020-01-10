//
//  NSObjectExtensionTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/1/10.
//  Copyright © 2020 李天星. All rights reserved.
//

import XCTest
import LTXiOSUtils
import QorumLogs

@testable import LTXiOSUtils

class NSObjectExtensionTest: XCTestCase {

    func testNotificationCenter() {
        initNotification()
        self.postNotification("name", userInfo: nil)
        self.postNotification("age", userInfo: nil)
    }

    func initNotification() {
        self.observerNotification("name") { _ in
            QL1("收到name通知")
        }
        self.observerNotification("age") { _ in
            QL1("收到age通知")
        }
    }
}
