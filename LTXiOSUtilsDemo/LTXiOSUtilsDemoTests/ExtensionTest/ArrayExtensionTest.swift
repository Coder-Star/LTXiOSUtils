//
//  ArrayExtensionTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/1/8.
//  Copyright © 2020 李天星. All rights reserved.
//

import XCTest
import LTXiOSUtils
import QorumLogs

@testable import LTXiOSUtils

class ArrayExtensionTest: XCTestCase {

    func testArrayExtension() {
        let arr = [1,1,2,3,4,4,5,5]
        let list = [["1":"张三"],["1":"张三"],["1":"李四"]]
        Log.d(arr.removeDuplicate{$0})
        Log.d(list.removeDuplicate{$0["1"]})
    }
}
