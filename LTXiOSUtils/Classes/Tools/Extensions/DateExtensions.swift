//
//  DateExtensions.swift
//  LTXiOSUtils
//  时间扩展
//  Created by 李天星 on 2019/8/2.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation

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
public extension Date {

    /// Date格式化
    ///
    /// - Parameter format: 格式化类型
    /// - Returns: 格式化后的字符串
    func formatDate(format: DateFormateType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format.rawValue
        let dateString = dateFormatter.string(from: self)
        return dateString
    }

    /// 获取星期
    var weekDay: String {
        let weekDays = [NSNull.init(),"日","一","二","三","四","五","六"] as [Any]
        let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
        let timeZone = TimeZone.current
        calendar?.timeZone = timeZone
        let calendarUnit = NSCalendar.Unit.weekday
        let theComponents = calendar?.components(calendarUnit, from:self)
        if let index = theComponents?.weekday , weekDays.count > index , let weekday = weekDays[index] as? String {
            return weekday
        }
        return ""
    }

}

// MARK: - 当前时间等相关
public extension Date {

    /// 秒级时间戳 - 10位
    var timeStamp: Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }

    /// 获取秒级时间戳 - 10位
    var timeStampStr: String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }

    /// 获取毫秒级时间戳 - 13位
       var milliStamp : CLongLong {
           let timeInterval: TimeInterval = self.timeIntervalSince1970
           let millisecond = CLongLong(round(timeInterval*1000))
           return millisecond
       }

    /// 获取毫秒级时间戳 - 13位
    var milliStampStr : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }

    /// 获取当前时间
    static func getCurrentTime() -> String {
        return Date().formatDate(format: .YMDHMS)
    }

    /// 获取当前日期
    static func getCurrentDate() -> String {
        return Date().formatDate(format: .YMD)
    }

}

// MARK: - DispatchTime扩展，构造函数
extension DispatchTime: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {

    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }

    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}
