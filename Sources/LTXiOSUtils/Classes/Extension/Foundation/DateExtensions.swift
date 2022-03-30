//
//  DateExtensions.swift
//  LTXiOSUtils
//  时间扩展
//  Created by CoderStar on 2019/8/2.
//  Copyright © 2019年 CoderStar. All rights reserved.
//

import Foundation

extension Date: TxExtensionWrapperCompatibleValue {}

/// 日期格式化类型
public enum DateFormateType: String {
    /// - YMDHMS:  年月日时分秒/2019-01-01 12:00:00
    case YMDHMS = "yyyy-MM-dd HH:mm:ss"
    /// - YMDHM:   年月日时分/2019-01-01 12:00
    case YMDHM = "yyyy-MM-dd HH:mm"
    /// - MDHM:    月日时分/01-01 12:00
    case MDHM = "MM-dd HH:mm"
    /// - YMDE:    日期星期/2019-01-01 星期一
    case YMDE = "yyyy-MM-dd EEEE"
    /// - YMD:     年月日/2019-01-01
    case YMD = "yyyy-MM-dd"
    /// - HMS:     时分秒/12:00:00
    case HMS = "HH:mm:ss"
    /// - YM:      年月日/2019-01
    case YM = "yyyy-MM"
    /// - MD:      月日/2019-01
    case MD = "MM-dd"
    /// - HM:      时分/12:00
    case HM = "HH:mm"
}

// MARK: - 日期扩展

extension TxExtensionWrapper where Base == Date {
    /// Date格式化
    ///
    /// - Parameter format: 格式化类型
    /// - Returns: 格式化后的字符串
    public func formatDate(format: DateFormateType) -> String {
        return formatDate(formatStr: format.rawValue)
    }

    /// Date格式化
    ///
    /// - Parameter format: 日期格式
    /// - Returns: 格式化后的字符串
    public func formatDate(formatStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = formatStr
        dateFormatter.locale = Locale.current
        let dateString = dateFormatter.string(from: base)
        return dateString
    }

    /// 获取星期
    public var weekDay: String {
        let weekDays = [NSNull(), "日", "一", "二", "三", "四", "五", "六"] as [Any]
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        let timeZone = TimeZone.current
        calendar?.timeZone = timeZone
        let calendarUnit = NSCalendar.Unit.weekday
        let theComponents = calendar?.components(calendarUnit, from: base)
        if let index = theComponents?.weekday, weekDays.count > index, let weekday = weekDays[index] as? String {
            return weekday
        }
        return ""
    }

    /// 获取相对指定时间之前几天或者之后几天的日期，之前的填入负数
    /// - Parameter days: 日期，单位为天
    public func getDateByDays(days: Int) -> Date {
        let date = Date(timeInterval: TimeInterval(days * 24 * 60 * 60), since: base)
        return date
    }
}

// MARK: - 当前时间等相关

extension TxExtensionWrapper where Base == Date {
    /// 秒级时间戳 - 10位
    public var timeStamp: Int {
        let timeInterval = base.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }

    /// 获取秒级时间戳 - 10位
    public var timeStampStr: String {
        return "\(timeStamp)"
    }

    /// 获取毫秒级时间戳 - 13位
    public var milliTimeStamp: Int {
        let timeInterval = base.timeIntervalSince1970
        let millisecond = Int(round(timeInterval * 1_000))
        return millisecond
    }

    /// 获取毫秒级时间戳 - 13位
    public var milliTimeStampStr: String {
        return "\(milliTimeStamp)"
    }

    /// 获取当前时间
    public static func getCurrentTime() -> String {
        return Date().tx.formatDate(format: .YMDHMS)
    }

    /// 获取当前日期
    public static func getCurrentDate() -> String {
        return Date().tx.formatDate(format: .YMD)
    }
}

// MARK: - 时间戳转时间

extension TxExtensionWrapper where Base == TimeInterval {
    /// 时间戳(毫秒)转时间
    public var dateAsMilliStamp: Date {
        let timeInterval = base / 1_000
        return Date(timeIntervalSince1970: timeInterval)
    }

    /// 时间戳转时间字符串
    /// - Parameters:
    ///   - format: 时间格式化格式
    public func toDateStrAsMilliStamp(format: DateFormateType) -> String {
        return dateAsMilliStamp.tx.formatDate(format: format)
    }

    /// 时间戳(秒)转时间
    public var dateAsTimeStamp: Date {
        return Date(timeIntervalSince1970: base)
    }

    /// 时间戳(秒)转时间字符串
    /// - Parameters:
    ///   - format: 时间格式化格式
    public func toDateStrAsTimeStamp(format: DateFormateType) -> String {
        return dateAsTimeStamp.tx.formatDate(format: format)
    }
}
