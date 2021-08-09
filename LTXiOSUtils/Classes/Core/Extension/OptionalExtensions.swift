//
//  OptionalExtensions.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2019/11/21.
//

import Foundation

extension Optional {
    /// 判断是否为空
    public var isNil: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }

    /// 判断是否有值
    public var isNotNil: Bool {
        return !isNil
    }

    /// 返回解包后的值或者默认值
    public func or(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }

    /// 返回解包后的值或`else`表达式的值
    public func or(else: @autoclosure () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }

    /// 返回解包后的值或执行闭包返回值
    public func or(else: () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }

    /// 当可选值不为空时，执行 `some` 闭包
    public func on(some: () throws -> Void) rethrows {
        if self != nil { try some() }
    }

    /// 当可选值为空时，执行 `none` 闭包
    public func on(none: () throws -> Void) rethrows {
        if self == nil { try none() }
    }
}
