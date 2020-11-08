//
//  BaseUser.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/11/6.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

class BaseUser {
  var name = ""
  var age = 0
}

class NSBaseUser: NSObject {
    @objc
    dynamic var name = ""

    @objc
    var age = 0

    @objc
    private var sex = "私有性别"

    override func value(forUndefinedKey key: String) -> Any? {
        return "进入KVO取值错误"
    }

    override class func setNilValueForKey(_ key: String) {
        Log.d("key赋值nil")

    }

    override var description: String {
        return "\(name) \(age) \(sex)"
    }
}
