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

// MARK: - 验证格式
extension String {
    /// 是否邮箱地址
    public var isEmail: Bool {
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// 是否手机号
    public var isMobiel: Bool {
        let pattern = "^1[0-9]{10}$"
        let regex = NSPredicate(format: "SELF MATCHES %@",pattern)
        return regex.evaluate(with: self)
    }

    /// 是否身份证号
    public var isIDNumber: Bool {
        let pattern = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let regex = NSPredicate(format: "SELF MATCHES %@",pattern)
        return regex.evaluate(with: self)
    }

    /// 是否车牌号
    public var isCarNumber: Bool {
        if self.count != 7 , self.count != 8{
            return false
        }
        var pattern = ""
        if self.count == 7 {
            pattern = "^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$"
        } else if self.count == 8 {
            pattern = "^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}(([0-9]{5}[DF]$)|([DF][A-HJ-NP-Z0-9][0-9]{4}$))"
        }
        let regex = NSPredicate(format: "SELF MATCHES %@",pattern)
        return regex.evaluate(with: self)
    }

}

// MARK: - 转为其他类型
extension String {

   /// 中文转拼音
   /// 会有多音字问题，并且效率较低，不适合大批量数据
   /// - Returns: 拼音
   public func toPinYin() -> String {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        return string.replacingOccurrences(of:" ", with: "")
    }
}
