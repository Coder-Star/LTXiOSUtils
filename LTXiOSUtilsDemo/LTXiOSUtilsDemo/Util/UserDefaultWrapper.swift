//
//  UserDefaultWrapper.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2021/1/30.
//  Copyright © 2021 李天星. All rights reserved.
//

import Foundation

/// UserDefaultWrapper
@propertyWrapper
public struct UserDefaultWrapper<T> {

    let key: String
    let defaultValue: T

    /// 构造函数
    /// - Parameters:
    ///   - key: 存储key值
    ///   - defaultValue: 当存储值不存在时默认值
    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    /// wrappedValue是@propertyWrapper必须需要实现的属性
    /// 当操作我们要包裹的属性时，其具体的set、get方法实际上走的都是wrappedValue的get、set方法
   public var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}
