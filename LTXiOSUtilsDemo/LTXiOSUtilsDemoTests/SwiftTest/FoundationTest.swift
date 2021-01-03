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
        //  zip 是将两个序列的元素，一一对应合并成元组，生成一个新序列
        let dic = Dictionary(uniqueKeysWithValues: zip(["name", "age"], ["张三"]))
        Log.d(dic)

        for item in dic.enumerated() {
            Log.d(item.element)
        }
    }

    func testArray() {

    }

}
