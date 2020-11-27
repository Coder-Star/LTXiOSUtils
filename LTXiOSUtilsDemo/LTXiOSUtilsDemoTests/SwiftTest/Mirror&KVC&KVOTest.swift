//
//  MirrorTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/11/5.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import XCTest
import LTXiOSUtils

class User: CustomStringConvertible {
    var name = ""
    var age = 0

    var description: String {
        return name + "\(age)"
    }
}
/**
 Swift中如果想使用KVC，需要类继承自NSObject，并且对需要使用KVC的属性进行@objc修饰
 */
class NSUser: NSObject {
    var name = ""

    @objc
    var age = 0

    override var description: String {
        return name + "\(age)"
    }

    override class func value(forUndefinedKey key: String) -> Any? {
       return "进入错误"
    }

    override class func setValue(_ value: Any?, forUndefinedKey key: String) {

    }
    
}

class MirrorTest: XCTestCase {

    func test() {
        let user = User()
        user.name = "张三"
        user.age = 18
        let mirror = Mirror(reflecting: user)
        // 对象的属性key及value
        for item in mirror.children {
            Log.d(item.label)
            Log.d(item.value)
        }
        // 对象的类型，具体类型，User
        Log.d(mirror.subjectType)
        // 对象的元类型，class，struct等
        Log.d(mirror.displayStyle)
        // 对象父类反射
        Log.d(mirror.superclassMirror?.subjectType)
    }

    func testKVC() {
        let user = NSUser()
        user.name = "张三"
        user.age = 18

        Log.d(user.value(forKey: "age1"))

        Log.d(user)
    }


    func testKeyPath() {
        let user = User()
        user.name = "张三"
        user.age = 18

        Log.d(user[keyPath: \User.name])

        var userList = [User]()
        userList.append(user)

        let names = userList.map(\.name)
        Log.d(names)

        userList.tx.sorted(by: \.name)
    }

    // 利用keyPath赋值防止循环引用
    func setter<Object: AnyObject, Value>(for object: Object, keyPath: ReferenceWritableKeyPath<Object, Value>) -> (Value) -> Void {
        return { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
