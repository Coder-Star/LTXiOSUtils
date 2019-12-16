//
//  DateExtensions.swift
//  LTXiOSUtils
//  时间扩展
//  Created by 李天星 on 2019/8/2.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation

/// 日期格式化类型
///
/// - YMDHMS:  年月日时分秒/2019-01-01 12:00:00
/// - YMDHM:   年月日时分/2019-01-01 12:00
/// - MDHM:    月日时分/01-01 12:00
/// - YMDE:    日期星期/2019-01-01 星期一
/// - YMD:     年月日/2019-01-01
/// - YM:      年月日/2019-01
/// - MD:      月日/2019-01
/// - HMS:     时分秒/12:00:00
/// - HM:      时分/12:00
public enum DateFormateType: String {
    case YMDHMS = "yyyy-MM-dd HH:mm:ss"
    case YMDHM = "yyyy-MM-dd HH:mm"
    case MDHM = "MM-dd HH:mm"
    case YMDE = "yyyy-MM-dd EEEE"
    case YMD = "yyyy-MM-dd"
    case HMS = "HH:mm:ss"
    case YM = "yyyy-MM"
    case MD = "MM-dd"
    case HM = "HH:mm"
}

// MARK: - 日期扩展
extension Date {

    /// Date格式化
    ///
    /// - Parameter format: 格式化类型
    /// - Returns: 格式化后的字符串
    public func formatDate(format: DateFormateType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format.rawValue
        let dateString = dateFormatter.string(from: self)
        return dateString
    }

}

extension DispatchTime: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {

    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }

    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}

extension DispatchQueue {
    /// 延时扩展
    ///
    /// - Parameters:
    ///   - delay: 延时时间
    ///   - execute: 闭包执行
    public func delay(_ delay: Double, execute: @escaping () -> Void) {
        asyncAfter(deadline: DispatchTime.init(floatLiteral: delay), execute: execute)
    }
}
