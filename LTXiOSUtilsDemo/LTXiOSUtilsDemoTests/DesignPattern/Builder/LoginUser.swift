//
//  LoginUser.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/11/24.
//  Copyright © 2020 李天星. All rights reserved.
//

/**
 建造器模式
 应用场景：生成对象的过程中有很多种生成方式，一些参数可选，一些参数不可选
 swift不支持静态内部类，java支持，如果支持内部类，写起来效果更好,如下 LoginUserBuilder.Builder().XXX.XXX.build()
 */

import Foundation
import XCTest

class Test: XCTestCase {
    func test() {
        let user = LoginUserBuilder(loginName: "loginName", password: "password")
            .setAge(age: "18")
            .setSex(age: "男")
            .build()
        print(user)
    }
}

class LoginUser: CustomStringConvertible {
    // 登录名 必填
    var loginName: String
    /// 密码 必填
    var password: String

    /// 年龄 不必填
    var age = ""
    /// 性别 不必填
    var sex = ""

    fileprivate init(builder: LoginUserBuilder) {
        self.loginName = builder.loginName
        self.password = builder.password
        self.age = builder.age
        self.sex = builder.sex
    }

    var description: String {
        return "\(loginName) + \(password) + \(age) + \(sex)"
    }
}

class LoginUserBuilder {
    // 登录名 必填
    var loginName: String
    /// 密码 必填
    var password: String

    /// 年龄 不必填
    var age = ""
    /// 性别 不必填
    var sex = ""


    init(loginName: String, password: String) {
        self.loginName = loginName
        self.password = password
    }

    func setAge(age: String) -> LoginUserBuilder {
        self.age = age
        return self
    }

    func setSex(age: String) -> LoginUserBuilder {
        self.sex = age
        return self
    }

    func build() -> LoginUser {
        return LoginUser(builder: self)
    }
}
