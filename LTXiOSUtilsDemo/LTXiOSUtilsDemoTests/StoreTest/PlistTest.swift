//
//  PlistTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/8/30.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import XCTest
import LTXiOSUtils

class PlistTest: XCTestCase {

    func test() {
        let path = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)
        let listPath = path.appendingPathComponent("list").appendingPathExtension("plist")
        Log.d(listPath)
        let list: NSArray = [1, 2, 3, 4]
        list.write(toFile: listPath.path, atomically: true)


        let stringPath = path.appendingPathComponent("string").appendingPathExtension("plist")
        Log.d(stringPath)
        let str = "123"
        try? str.write(toFile: stringPath.path, atomically: true, encoding: .utf8)
    }
}
