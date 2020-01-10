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

extension Notification.Name {
    static let name = Notification.Name("name")
    static let age = Notification.Name("age")
}

class NSObjectExtensionTest: XCTestCase {

    func testNotificationCenter() {
        initNotification()
        self.postNotification(.name)
        self.postNotification(.age, userInfo: ["age":24])
    }

    func initNotification() {
        self.observerNotification(.name) {
            QL1("收到name通知")
        }
        self.observerNotification(.age) { notification in
            if let age = notification.userInfo?["age"] as? Int {
                QL1(age)
            }
            QL1("收到age通知")
        }
    }
}
