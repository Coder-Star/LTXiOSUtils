//
//  UserDefaultsProtocolTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/1/10.
//  Copyright © 2020 李天星. All rights reserved.
//

import XCTest
import LTXiOSUtils
import QorumLogs

@testable import LTXiOSUtils

enum UserInfoEnum: String {
    case name
}

extension UserInfoEnum: UserDefaultsProtocol {
    var key: String {
        return self.rawValue
    }
}

class UserDefaultsProtocolTest: XCTestCase {
    func test() {
        UserInfoEnum.name.save(int: 5)
        Log.d(UserInfoEnum.name.int)
    }
}



