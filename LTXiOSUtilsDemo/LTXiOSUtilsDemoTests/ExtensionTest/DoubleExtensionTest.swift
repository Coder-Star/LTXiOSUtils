//
//  DoubleExtensionTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/3/20.
//  Copyright © 2020 李天星. All rights reserved.
//

import XCTest
import LTXiOSUtils

@testable import LTXiOSUtils

class DoubleExtensionTest: XCTestCase {

    func testDoubleExtension() {
        let floatInfo: Float = 0.4111
        let doubleInfo: Double = 0.4111
        Log.d("\(doubleInfo * 1000)")
        Log.d((doubleInfo * 1000).removeSuffixZero)

        Log.d("\(Double(floatInfo * 1000))")
        Log.d(Double(floatInfo * 1000).removeSuffixZero)
    }
}
