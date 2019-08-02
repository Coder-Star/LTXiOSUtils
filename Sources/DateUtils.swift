//
//  DateUtils.swift
//  LTXiOSUtils
//  日期工具类，包含扩展
//  Created by 李天星 on 2019/8/2.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation

public enum DateFormateType:String{
    case YMDHMS = "yyyy-MM-dd HH:mm:ss" //年月日时分秒 2019-01-01 12:00:00
    case YMDHM = "yyyy-MM-dd HH:mm"  // 年月日时分 2019-01-01 12:00
    case MDHM = "MM-dd HH:mm"  // 月日时分 01-01 12:00
    case YMD = "yyyy-MM-dd"  // 年月日 2019-01-01
    case YM = "yyyy-MM"  // 年月日 2019-01
    case MD = "MM-dd"  // 月日 2019-01
    case HMS = "HH:mm:ss" // 时分秒 12:00:00
    case HM = "HH:mm" // 时分 12:00
}

open class DateUtils:NSObject{
    
}

extension Date{
    //根据格式对日期进行格式化
   public func formatDate(format: DateFormateType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format.rawValue
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
