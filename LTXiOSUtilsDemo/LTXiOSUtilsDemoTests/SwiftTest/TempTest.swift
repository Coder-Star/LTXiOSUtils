//
//  TempTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/12/14.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import XCTest
import LTXiOSUtilsDemo

var globalBlock: (_ info: String) -> Void = { info in }

class TempTest: XCTestCase {

    func testDescription() {
        var list = [5,1,2]
        list.sort { m1,m2 in
            Log.d(m1)
            Log.d(m2)
            return m1 < m2

        }
        Log.d(list)

//        let list = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
//        var m = list.count
//        let n = list[0].count
//
//        for index in 0..<n {
//            for tempIndex in 0..<m {
//                print(list[tempIndex][index])
//            }
//            m = m - 1
//            for tempIndex1 in index..<n {
//                print(list[index][tempIndex1])
//            }
//        }
    }

    func test() {
        Log.d(UserDefaultsConfig.username)
        UserDefaultsConfig.username = "123"
        Log.d(UserDefaults.standard.object(forKey: "username"))
    }

    func testBlock() {
        Log.d(globalBlock) // 打印为 Function
    }
}

struct UserDefaultsConfig {
    @UserDefaultWrapper("hadShownGuideView", defaultValue: true)
    static var hadShownGuideView: Bool

    ///保存用户名称
    @UserDefaultWrapper("username", defaultValue: "unknown")
    static var username: String
}