//
//  StringUtil.swift
//  LTXiOSUtils
//  字符串工具类以及扩展
//  Created by 李天星 on 2019/11/18.
//

import Foundation

/// 字符串工具类
open class StringUtil:NSObject {

}

// MARK: - 字符串扩展
extension String {

    /// 截取字符串前指定位
    ///
    /// - Parameter count: 位数值
    /// - Returns: 截取后的字符串
    public func getPrefix(count:Int) -> String {
        var resultStr = ""
        if count <= 0 || self.isEmpty || self.count < count {
            resultStr = self
        } else {
            resultStr = String(self.prefix(count))
        }
        return resultStr
    }

    /// 截取字符串后几位
    ///
    /// - Parameter count: 位数值
    /// - Returns: 截取后的字符串
    public func getSuffix(count:Int) -> String {
        var resultStr = ""
        if count <= 0 || self.isEmpty || self.count < count {
            resultStr = self
        } else {
            resultStr = String(self.suffix(count))
        }
        return resultStr
    }

    /// 字符串是否不为空
    public var isNotEmpty:Bool {
        return !self.isEmpty
    }

    /// 字符串是否为空(去除空格符以及换行符)
    public var isContentEmpty:Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// 字符串是否不为空(去除空格符以及换行符)
    public var isNotContentEmpty:Bool {
        return !self.isContentEmpty
    }
}
