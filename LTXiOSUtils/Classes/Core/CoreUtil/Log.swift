//
//  Log.swift
//  LTXiOSUtils
//  日志工具类
//  Created by 李天星 on 2020/2/23.
//

import Foundation
import UIKit

/// 日志等级
public enum LogLevel: Int {
    /// verbose
    case verbose = 0
    /// debug
    case debug = 1
    /// info
    case info = 2
    /// warning
    case warning = 3
    /// error
    case error = 4
}

/// 日志工具
public struct Log {

    /// 日志开关
    public static var enabled = false
    /// 日志显示最低等级
    public static var minShowLogLevel: LogLevel = .verbose

// MARK: - 图标
    /// verbose下的日志颜色
    public static var verboseEmojis = "💜"
    /// debug下的日志颜色
    public static var debugEmojis = "💙"
    /// info下的日志颜色
    public static var infoEmojis = "💚"
    /// warning下的日志颜色
    public static var warningEmojis = "💛"
    /// error下的日志颜色
    public static var errorEmojis = "❤️"

    /// verbose日志
    public static func v<T>(_ verbose: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        if Log.shouldLog(level: .verbose) {
            printLog(verbose, file: file, function: function, line: line, level: .verbose)
        }
    }

    /// debug日志
    public static func d<T>(_ debug: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        if Log.shouldLog(level: .debug) {
            printLog(debug, file: file, function: function, line: line, level: .debug)
        }
    }

    /// info日志
    public static func i<T>(_ info: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        if Log.shouldLog(level: .info) {
            printLog(info, file: file, function: function, line: line, level: .info)
        }
    }

    /// warning日志
    public static func w<T>(_ warning: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        if Log.shouldLog(level: .warning) {
            printLog(warning, file: file, function: function, line: line, level: .warning)
        }
    }

    /// error日志
    public static func e<T>(_ error: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        if Log.shouldLog(level: .error) {
            printLog(error, file: file, function: function, line: line, level: .error)
        }
    }

}

private extension Log {

    private static func printLog<T>(_ log: T, file: String, function: String, line: Int, level: LogLevel) {
        let fileExtension = file.ns.lastPathComponent.ns.pathExtension //文件名称
        let filename = file.ns.lastPathComponent.ns.deletingPathExtension //文件扩展名
        let time = getCurrentTime()
        let informationPart = "\(time)-\(filename).\(fileExtension):\(line) \(function):"
        print("\(formatLog(informationPart, level: nil))", terminator: "") //文件、行号等信息
        print("\(formatLog(log, level: level))\n", terminator: "") // 具体日志
    }

    private static func shouldLog(level: LogLevel) -> Bool {
        if !Log.enabled {
            return false
        } else if level.rawValue < Log.minShowLogLevel.rawValue {
            return false
        }
        return true
    }

    private static func formatLog<T>(_ object: T, level: LogLevel?) -> String {
        return "\(Log.getEmojis(level: level))\(object)\(Log.getEmojis(level: level))"
    }

    private static func getEmojis(level: LogLevel?) -> String {
        guard let logLevel = level else {
            return ""
        }
        switch logLevel {
        case .verbose:
            return Log.verboseEmojis
        case .debug:
            return Log.debugEmojis
        case .info:
            return Log.infoEmojis
        case .warning:
            return Log.warningEmojis
        case .error:
            return Log.errorEmojis
        }
    }

    private static func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }

}

private extension String {
    var ns: NSString { return self as NSString }
}
