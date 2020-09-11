//
//  FoundationTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/9/11.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import XCTest
import LTXiOSUtils

class FoundationTest: XCTestCase {

    func testDic() {
        let dic = Dictionary(uniqueKeysWithValues: zip(["name", "age"], ["张三"]))
        Log.d(dic)
    }

}
