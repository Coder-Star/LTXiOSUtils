//
//  DebugUtils.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/11/13.
//

import Foundation

/// 调试工具类
public struct DebugUtils {}

extension DebugUtils {
    /// 获取内存地址
    /// - Parameter values:
    /// - Parameter o: 地址，使用`&`符号
    /// - Returns: 地址
    public static func address(_ o: UnsafePointer<Void>) -> String {
        let addr = unsafeBitCast(o, to: Int.self)
        return NSString(format: "%p", addr) as String
    }

    /// 获取class的地址
    /// - Parameter o: 类实例
    /// - Returns: 地址
    public static func address<T: AnyObject>(_ o: T) -> String {
        let addr = unsafeBitCast(o, to: Int.self)
        return NSString(format: "%p", addr) as String
    }
}
