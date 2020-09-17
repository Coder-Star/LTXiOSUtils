//
//  StringExtensions.swift
//  LTXiOSUtils
//  字符串扩展
//  Created by 李天星 on 2019/11/18.
//

import Foundation

extension String: TxExtensionWrapperProtocol {}

// MARK: - 字符串截取
extension TxExtensionWrapper where Base == String {

    /// 截取字符串前指定位，异常情况返回原字符串
    ///
    /// - Parameter count: 位数值
    /// - Returns: 截取后的字符串
    public func getPrefix(count: Int) -> String {
        if count <= 0 || self.base.isEmpty || self.base.count < count {
            return self.base
        }
        return String(self.base.prefix(count))
    }

    /// 截取字符串后几位，异常情况返回原字符串
    ///
    /// - Parameter count: 位数值
    /// - Returns: 截取后的字符串
    public func getSuffix(count: Int) -> String {
        if count <= 0 || self.base.isEmpty || self.base.count < count {
            return self.base
        }
        return String(self.base.suffix(count))
    }

    /// 截取字符串，0位开始，左闭右开
    ///
    /// - Parameters:
    ///   - start: 起始位
    ///   - end: 终止位
    /// - Returns: 截取后的字符串
    public func getSubString(start: Int, end: Int) -> String {
        if start <= 0 || end <= 0 || start > end {
            return self.base
        }
        if self.base.isEmpty {
            return self.base
        }
        if self.base.count < end {
            return self.base
        }
        let startStr = self.base.index(self.base.startIndex, offsetBy: start)
        let endStr = self.base.index(self.base.startIndex, offsetBy: end)
        return String(self.base[startStr..<endStr])
    }
}

// MARK: - 日期时间相关
extension TxExtensionWrapper where Base == String {

    /// 时间转日期
    ///
    /// - Parameter dateType: 日期类型
    /// - Returns: 日期
    public func toDate(dateType: DateFormateType) -> Date? {
        return self.toDate(dateTypeStr: dateType.rawValue)
    }

    /// 时间转日期
    ///
    /// - Parameter dateType: 日期类型格式
    /// - Returns: 日期
    public func toDate(dateTypeStr: String) -> Date? {
        let selfLowercased = self.base.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().replacingOccurrences(of: "T", with: " ")
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.calendar = Calendar.current
        formatter.dateFormat = dateTypeStr
        return formatter.date(from: selfLowercased)
    }

    /// 截取时间字符串中的某一部分
    /// - Parameter dateType: 日期类型
    public func getDateStr(dateType: DateFormateType) -> String {
        switch dateType {
        case .YMDHMS:
            return self.getPrefix(count: 11) + self.getSubString(start: 11, end: 19)
        case .YMDHM:
            return self.getPrefix(count: 11) + self.getSubString(start: 11, end: 16)
        case .MDHM:
            return self.getSubString(start: 5, end: 11) + self.getSubString(start: 11, end: 16)
        case .YMD:
            return self.getPrefix(count: 10)
        case .HMS:
            return self.getSubString(start: 11, end: 19)
        case .YM:
            return self.getPrefix(count: 7)
        case .MD:
            return self.getSubString(start: 5, end: 10)
        case .HM:
            return self.getSubString(start: 11, end: 16)
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
        return self.base.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// 是否手机号
    public var isMobile: Bool {
        let pattern = "^1[0-9]{10}$"
        let regex = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regex.evaluate(with: self.base)
    }

    /// 是否身份证号
    public var isIDNumber: Bool {
        let pattern = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let regex = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regex.evaluate(with: self.base)
    }

    /// 是否车牌号
    public var isCarNumber: Bool {
        if self.base.count != 7, self.base.count != 8 {
            return false
        }
        var pattern = ""
        if self.base.count == 7 {
            pattern = "^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$"
        } else if self.base.count == 8 {
            pattern = "^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}(([0-9]{5}[DF]$)|([DF][A-HJ-NP-Z0-9][0-9]{4}$))"
        }
        let regex = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regex.evaluate(with: self.base)
    }

    /// 是否http链接(包含https)
    public var isNetworkUrl: Bool {
        guard let url = URL(string: self.base) else { return false }
        return url.scheme == "https" || url.scheme == "http"
    }

}

// MARK: - 转为其他类型
extension TxExtensionWrapper where Base == String {

    /// 中文转拼音
    /// 会有多音字问题，并且效率较低，不适合大批量数据
    /// - Returns: 拼音
    public func toPinYin() -> String {
        let mutableString = NSMutableString(string: self.base)
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
        let className = nameSpace.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "-", with: "_") + "." + self.base
        return NSClassFromString(className)
    }
}

// MARK: - 判断是否为空
extension TxExtensionWrapper where Base == String {

    /// 字符串是否不为空
    public var isNotEmpty: Bool {
        return !self.base.isEmpty
    }

    /// 字符串是否为空(去除空格符以及换行符)
    public var isContentEmpty: Bool {
        return self.base.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// 字符串是否不为空(去除空格符以及换行符)
    public var isNotContentEmpty: Bool {
        return !self.isContentEmpty
    }
}

// MARK: - 编码
extension TxExtensionWrapper where Base == String {

    /// url编码
    public var urlEncode: String? {
        return self.base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    /// url解码
    public var urlDecode: String? {
        return self.base.removingPercentEncoding
    }

    /// base64编码
    public var base64Encode: String? {
        let data = self.base.data(using: .utf8)
        let base64 = data?.base64EncodedString()
        return base64
    }

    /// base64解码
    public var base64Decode: String? {
        guard let data = Data(base64Encoded: self.base) else {
            return nil
        }
        let str = String(data: data, encoding: .utf8)
        return str
    }
}

// MARK: - 尺寸相关
extension TxExtensionWrapper where Base == String {

    /// 获取指定宽度、字体的字符串高度
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 宽度
    public func heightWithStr(font: UIFont, width: CGFloat) -> CGFloat {
        let attribute = [NSAttributedString.Key.font: font]
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = self.base.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: options, attributes: attribute, context: nil).size
        return size.height
    }

    /// 获取指定高度、字体的字符串宽度
    /// - Parameters:
    ///   - font: 字体
    ///   - height: 高度
    public func widthWithStr(font: UIFont, height: CGFloat) -> CGFloat {
        let attribute = [NSAttributedString.Key.font: font]
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = self.base.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height), options: options, attributes: attribute, context: nil).size
        return size.width
    }
}

// MARK: - 富文本相关
extension TxExtensionWrapper where Base == String {

    /// 转为富文本
    public var attributedString: NSMutableAttributedString {
        return NSMutableAttributedString(string: self.base)
    }
}
