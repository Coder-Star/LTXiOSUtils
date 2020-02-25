//
//  SwiftyUserDefaultsTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/1/10.
//  Copyright © 2020 李天星. All rights reserved.
//

import XCTest
import SwiftyUserDefaults
import QorumLogs

@testable import SwiftyUserDefaults

public let defaults = UserDefaults.standard

extension DefaultsKeys {
    static let launchCount = DefaultsKey<Int>("launchCount",defaultValue: 0)
    struct Login {
        static let username = DefaultsKey<String>("username",defaultValue:"0000")
    }
}

class SwiftyUserDefaultsTest: XCTestCase {

    func test() {
        save()
        get()
        remove()
    }

    func save() {
        defaults[.launchCount] = 2
        defaults[DefaultsKeys.Login.username] = "1111"
    }

    func get() {
        Log.d(defaults[.launchCount])
        Log.d(defaults[DefaultsKeys.Login.username])
    }

    func remove() {
        defaults.remove(DefaultsKey<Int>.launchCount)
    }
}
