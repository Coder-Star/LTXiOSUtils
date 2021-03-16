//
//  GCDTest.swift
//  LTXiOSUtilsDemoTests
//  
//  Created by 李天星 on 2020/8/26.
//  Copyright © 2020 李天星. All rights reserved.
//

import XCTest
import LTXiOSUtils

@testable import LTXiOSUtils

class Node: Equatable {
    let value: Int
    let next: Node?
    init(value: Int) {
        self.value = value
        self.next = nil
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.value == rhs.value && lhs.next == rhs.next
    }
}

class ListNodeTest: XCTestCase {
    func testDemo(nodeA: Node?, nodeB: Node?) -> Node {
        var tempNodeA = nodeA
        var tempNodeB = nodeB
        var lenNodeA = 1
        var lenNodeB = 1
        while tempNodeA != nil {
            tempNodeA = tempNodeA?.next!
            lenNodeA += 1
        }
        while tempNodeB != nil {
            tempNodeB = tempNodeB?.next!
            lenNodeB += 1
        }

        if lenNodeA > lenNodeB {
            var t = lenNodeA - lenNodeB
            while t != 0 {
                tempNodeA = tempNodeA!.next
                t -= 1
            }
        } else {
            var t = lenNodeB -  lenNodeA
            while t != 0 {
                tempNodeB = tempNodeB!.next
                t -= 1
            }
        }

        while tempNodeA != tempNodeB {
            tempNodeA = tempNodeA?.next
            tempNodeB = tempNodeB?.next
        }
        return tempNodeA!
    }

}

