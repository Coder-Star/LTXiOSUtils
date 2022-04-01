//
//  StringExtensions.swift
//  LTXiOSUtils
//  字符串扩展
//  Created by CoderStar on 2019/11/18.
//

import Foundation
import UIKit

extension String: TxExtensionWrapperCompatibleValue {}

// MARK: - 字符串截取

extension TxExtensionWrapper where Base == String {
    /// 截取字符串前指定位，异常情况返回原字符串
    ///
    /// - Parameter count: 位数值
    /// - Returns: 截取后的字符串
    public func getPrefix(count: Int) -> String {
        if count <= 0 || base.isEmpty || base.count < count {
            return base
        }
        return String(base.prefix(count))
    }

    /// 截取字符串后几位，异常情况返回原字符串
    ///
    /// - Parameter count: 位数值
    /// - Returns: 截取后的字符串
    public func getSuffix(count: Int) -> String {
        if count <= 0 || base.isEmpty || base.count < count {
            return base
        }
        return String(base.suffix(count))
    }

    /// 截取字符串，0位开始，左闭右开
    ///
    /// - Parameters:
    ///   - start: 起始位
    ///   - end: 终止位
    /// - Returns: 截取后的字符串
    public func getSubString(start: Int, end: Int) -> String {
        if start <= 0 || end <= 0 || start > end {
            return base
        }
        if base.isEmpty {
            return base
        }
        if base.count < end {
            return base
        }
        let startStr = base.index(base.startIndex, offsetBy: start)
        let endStr = base.index(base.startIndex, offsetBy: end)
        return String(base[startStr ..< endStr])
    }
}

// MARK: - 日期时间相关

extension TxExtensionWrapper where Base == String {
    /// 时间转日期
    ///
    /// - Parameter dateType: 日期类型
    /// - Returns: 日期
    public func toDate(dateType: DateFormateType) -> Date? {
        return toDate(dateTypeStr: dateType.rawValue)
    }

    /// 时间转日期
    ///
    /// - Parameter dateType: 日期类型格式
    /// - Returns: 日期
    public func toDate(dateTypeStr: String) -> Date? {
        let selfLowercased = base.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().replacingOccurrences(of: "T", with: " ")
        let formatter = DateFormatter()
        // 区域，如果设置成Current，会受到24小时/12小时的影响
        formatter.locale = Locale(identifier: "en_US_POSIX")
        // 时区
        formatter.timeZone = TimeZone.current
        // 日历
        formatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        formatter.dateFormat = dateTypeStr
        return formatter.date(from: selfLowercased)
    }

    /// 截取时间字符串中的某一部分
    /// - Parameter dateType: 日期类型
    public func getDateStr(dateType: DateFormateType) -> String {
        switch dateType {
        case .YMDHMS:
            return getPrefix(count: 11) + getSubString(start: 11, end: 19)
        case .YMDHM:
            return getPrefix(count: 11) + getSubString(start: 11, end: 16)
        case .MDHM:
            return getSubString(start: 5, end: 11) + getSubString(start: 11, end: 16)
        case .YMD:
            return getPrefix(count: 10)
        case .HMS:
            return getSubString(start: 11, end: 19)
        case .YM:
            return getPrefix(count: 7)
        case .MD:
            return getSubString(start: 5, end: 10)
        case .HM:
            return getSubString(start: 11, end: 16)
        default:
            return ""
        }
    }
}

// MARK: - 验证格式

extension TxExtensionWrapper where Base == String {
    /// 是否邮箱地址
    public var isEmail: Bool {
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return base.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// 是否手机号
    public var isMobile: Bool {
        let pattern = "^1[0-9]{10}$"
        let regex = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regex.evaluate(with: base)
    }

    /// 是否身份证号
    public var isIDNumber: Bool {
        let pattern = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let regex = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regex.evaluate(with: base)
    }

    /// 是否车牌号
    public var isCarNumber: Bool {
        if base.count != 7, base.count != 8 {
            return false
        }
        var pattern = ""
        if base.count == 7 {
            pattern = "^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$"
        } else if base.count == 8 {
            pattern = "^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}(([0-9]{5}[DF]$)|([DF][A-HJ-NP-Z0-9][0-9]{4}$))"
        }
        let regex = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regex.evaluate(with: base)
    }

    /// 是否http链接(包含https)
    public var isNetworkUrl: Bool {
        guard let url = URL(string: base) else { return false }
        return url.scheme == "https" || url.scheme == "http"
    }
}

// MARK: - 转为其他类型

extension TxExtensionWrapper where Base == String {
    /// 中文转拼音
    /// 会有多音字问题，并且效率较低，不适合大批量数据
    /// - Returns: 拼音
    public func toPinYin() -> String {
        let mutableString = NSMutableString(string: base)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        return string.replacingOccurrences(of: " ", with: "")
    }

    /*
     guard let className = "xxxxx".tx.classOfMainBundle as? UIViewController.Type else {
     return
     }
     */
    /// 字符串转为类，限制主工程代码使用
    public var classOfMainBundle: AnyClass? {
        guard let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            return nil
        }
        let className = nameSpace.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "-", with: "_") + "." + base
        return NSClassFromString(className)
    }
}

// MARK: - 编码

extension TxExtensionWrapper where Base == String {
    /// url编码
    /// 对特殊符号编码
    public var urlEncode: String? {
        return base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    /// url编码
    /// 对特殊符号不编码
    public var urlEncodeWithoutCharacters: String? {
        var charSet = CharacterSet.urlQueryAllowed
        charSet.insert(charactersIn: "!*'();:@&=+$,/?%#[]")
        return base.addingPercentEncoding(withAllowedCharacters: charSet)
    }

    /// url解码
    public var urlDecode: String? {
        return base.removingPercentEncoding
    }

    /// base64编码
    public var base64Encode: String? {
        let data = base.data(using: .utf8)
        let base64 = data?.base64EncodedString()
        return base64
    }

    /// base64解码
    public var base64Decode: String? {
        guard let data = Data(base64Encoded: base) else {
            return nil
        }
        let str = String(data: data, encoding: .utf8)
        return str
    }
}

// MARK: - 尺寸相关

extension TxExtensionWrapper where Base == String {
    /// 获取指定宽度、字体的字符串高度
    ///
    /// 不是绝对准确
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 宽度
    public func height(font: UIFont, width: CGFloat) -> CGFloat {
        let attribute = [NSAttributedString.Key.font: font]
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = base.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: options, attributes: attribute, context: nil).size
        return ceil(size.height)
    }

    /// 获取指定高度、字体的字符串宽度
    ///
    /// 不是绝对准确
    /// - Parameters:
    ///   - font: 字体
    ///   - height: 高度
    public func width(font: UIFont, height: CGFloat) -> CGFloat {
        let attribute = [NSAttributedString.Key.font: font]
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = base.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height), options: options, attributes: attribute, context: nil).size
        return ceil(size.width)
    }
}

// MARK: - 富文本相关

extension TxExtensionWrapper where Base == String {
    /// 转为富文本
    public var attributedString: NSMutableAttributedString {
        return NSMutableAttributedString(string: base)
    }
}

// MARK: - 字符串插值相关

// MARK: - 未使用命名空间

extension String.StringInterpolation {
    /// 字符串插值，提供设置默认值方法
    public mutating func appendInterpolation<T>(_ value: T?, _ defaultValue: T) {
        if let value = value {
            appendInterpolation(value)
        } else {
            appendInterpolation(defaultValue)
        }
    }
}
