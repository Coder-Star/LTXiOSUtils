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
    /// 打印结构体地址，转为16进制
    /// - Parameter values: 结构体，使用`&`符号
    public static func printAddressForStruct(_ values: UnsafeRawPointer...) {
        values.forEach { point in
            Log.d(String(Int(bitPattern: point), radix: 16))
        }
    }

    /// 打印class的地址，16进制
    /// - Parameter values: 类实例
    public static func printAddressForClass(_ values: Any...) {
        // 将地址转为16进制数
        values.forEach { value in
            Log.d(String(unsafeBitCast(value as AnyObject, to: Int.self), radix: 16))
        }
    }

    /// 打印class的地址，直接打印pointer
    /// - Parameter values: 类实例
    public static func printAddressForClassWithPointer(_ values: Any...) {
        values.forEach { value in
            Log.d(Unmanaged.passUnretained(value as AnyObject).toOpaque())
        }
    }
}
