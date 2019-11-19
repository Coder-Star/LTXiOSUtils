//
//  StringExtensions.swift
//  LTXiOSUtils
//  字符串扩展
//  Created by 李天星 on 2019/11/18.
//

import Foundation

// MARK: - 字符串扩展
extension String {

    /// 截取字符串前指定位，异常情况返回原字符串
    ///
    /// - Parameter count: 位数值
    /// - Returns: 截取后的字符串
    public func getPrefix(count: Int) -> String {
        if count <= 0 || self.isEmpty || self.count < count {
            return self
        }
        return String(self.prefix(count))
    }

    /// 截取字符串后几位，异常情况返回原字符串
    ///
    /// - Parameter count: 位数值
    /// - Returns: 截取后的字符串
    public func getSuffix(count: Int) -> String {
        if count <= 0 || self.isEmpty || self.count < count {
            return self
        }
        return String(self.suffix(count))
    }

    /// 截取字符串，0位开始，左闭右开
    ///
    /// - Parameters:
    ///   - start: 起始位
    ///   - end: 终止位
    /// - Returns: 截取后的字符串
    public func getSubString(start: Int, end: Int) -> String {
        if start <= 0 || end <= 0 || start > end {
           return self
        }
        if self.isEmpty {
            return self
        }
        if self.count < end {
            return self
        }
        let startStr = self.index(self.startIndex, offsetBy: start)
        let endStr = self.index(self.startIndex, offsetBy: end)
        return String(self[startStr..<endStr])
    }

    /// 时间转日期
    ///
    /// - Parameter dateType: 日期类型
    /// - Returns: 日期
    public func toDate(dateType: DateFormateType = .YMD) -> Date? {
        let selfLowercased = self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().replacingOccurrences(of: "T", with: " ")
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = dateType.rawValue
        return formatter.date(from: selfLowercased)
    }

    /// 字符串是否不为空
    public var isNotEmpty: Bool {
        return !self.isEmpty
    }

    /// 字符串是否为空(去除空格符以及换行符)
    public var isContentEmpty: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// 字符串是否不为空(去除空格符以及换行符)
    public var isNotContentEmpty: Bool {
        return !self.isContentEmpty
    }
}
