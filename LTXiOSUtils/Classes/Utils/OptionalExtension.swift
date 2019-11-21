//
//  OptionalExtension.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/11/21.
//

import Foundation

extension Optional {
    /// 判断是否为空
    var isNone: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }
    /// 判断是否有值
    var isSome: Bool {
        return !isNone
    }
    /// 返回解包后的值或者默认值
    func or(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }
    /// 返回解包后的值或`else`表达式的值
    func or(else: @autoclosure () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }
    /// 返回解包后的值或执行闭包返回值
    func or(else: () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }
    /// 当可选值不为空时，执行 `some` 闭包
    func on(some: () throws -> Void) rethrows {
        if self != nil { try some() }
    }
    /// 当可选值为空时，执行 `none` 闭包
    func on(none: () throws -> Void) rethrows {
        if self == nil { try none() }
    }
}
