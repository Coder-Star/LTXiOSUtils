//
//  FunctionTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/9/6.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import XCTest
import LTXiOSUtils

class FunctionTest: XCTestCase {

    func test() {
    
    }

    func testArray() {
        let arr = [1, 2, 3,]
        arr.forEach {
            Log.d($0)
        }
    }

}
