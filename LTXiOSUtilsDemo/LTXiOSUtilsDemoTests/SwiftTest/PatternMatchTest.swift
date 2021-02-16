//
//  PatternMatchTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2021/2/4.
//  Copyright © 2021 李天星. All rights reserved.
//

import Foundation
import XCTest
import LTXiOSUtils

class PatternMatchTest: XCTestCase {

    func testPatternMatch() {
        let list = [
            (x: 100, y: nil),
            (x: 1, y: 2),
            (x: 11, y: 22),
            (x: 111, y: 222),
        ]

        for item in list {
            switch item {
            // 通配符模式，其中 _ 标识全部，_? 标识非nil值
            case (_, _?):
                break
            // 值绑定模式
            case let (x, y):
                Log.d("\(x),\(String(describing: y))")
                break
            // 值绑定模式
            case (let x, let y):
                Log.d("\(x),\(String(describing: y))")
                break

            }
        }

        // 元祖模式
        for (x, _) in list {
            Log.d(x)
        }

        let age = 2
        if case 0...9 = age {
            Log.d(age)
        }

        guard case 0...9 = age else { return }
        Log.d(age)

        let ages: [Int?] = [2, 3, nil, 5]
        for case nil in ages { //匹配nil值
            Log.d("有nil值")
            break
        }

        for case let age? in ages { //age?是匹配非空值
            Log.d(age)
        }

        for case 2? in ages { //age?是匹配非空值
            Log.d(2)
        }



        let points = [(1, 0), (2, 1), (3, 0)]
        for case let (x, 0) in points {
            Log.d(x)
        }

        let num: Any = 6
        switch num {
        // 仅仅是判断num是否是Int类型，编译器并没有进行强转，编译器依然认为num是Any类型
        case is Int:
            Log.d(num)
        // 判断能不能将num强转成Int，如果可以就强转，然后赋值给n，最后n是Int类型，num还是Any类型
        case let n as Int:
            Log.d(n)
        default:
            break
        }

    }
}
