//
//  BaseTest.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/11/6.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

@objcMembers
class BaseTest: NSObject {
    var observation: NSKeyValueObservation!

    func getUser() -> BaseUser {
        let user = BaseUser()
        user.name = "张三"
        user.age = 18
        return user
    }

    func getNSUser() -> NSBaseUser {
        let user = NSBaseUser()
        user.name = "张三"
        user.age = 18
        return user
    }

    func test() {
        let user = getNSUser()
        observation = user.observe(\NSBaseUser.name, options: [.old, .new]) { user, change in
            Log.d(user)
            Log.d(change.oldValue)
            Log.d(change.newValue)
            Log.d(change)
        }
//        observation.invalidate() // 释放观察器
        Log.d(user.value(forKey: "age1"))
        user.name = "李四"
//        user.setValue("kvc赋值私有属性keyPath", forKeyPath: #keyPath(NSBaseUser.name))
        user.setValue("kvc赋值私有属性key", forKey: "name")
        user.setValue("kvc赋值私有属性", forKey: "sex")
        Log.d(user.value(forKey: "name"))
    }
}
