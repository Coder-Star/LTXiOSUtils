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

    private init(){}

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
        #if DEBUG
        if Log.shouldLog(level: .verbose) {
            printLog(verbose, file: file, function: function, line: line, level: .verbose)
        }
        #endif
    }

    /// debug日志
    public static func d<T>(_ debug: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        #if DEBUG
        if Log.shouldLog(level: .debug) {
            printLog(debug, file: file, function: function, line: line, level: .debug)
        }
        #endif
    }

    /// info日志
    public static func i<T>(_ info: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        #if DEBUG
        if Log.shouldLog(level: .info) {
            printLog(info, file: file, function: function, line: line, level: .info)
        }
        #endif
    }

    /// warning日志
    public static func w<T>(_ warning: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        #if DEBUG
        if Log.shouldLog(level: .warning) {
            printLog(warning, file: file, function: function, line: line, level: .warning)
        }
        #endif
    }

    /// error日志
    public static func e<T>(_ error: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        #if DEBUG
        if Log.shouldLog(level: .error) {
            printLog(error, file: file, function: function, line: line, level: .error)
        }
        #endif
    }

}

private extension Log {

    private static func printLog<T>(_ log: T, file: String, function: String, line: Int, level: LogLevel) {
        let fileExtension = ((file as NSString).lastPathComponent as NSString).pathExtension //文件名称
        let filename = ((file as NSString).lastPathComponent as NSString).deletingPathExtension //文件扩展名
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
        if let dict = object as? [String: Any] {
            return "\(Log.getEmojis(level: level))\(dict.logDescription())\(Log.getEmojis(level: level))"
        } else if let array = object as? [Any] {
            return "\(Log.getEmojis(level: level))\(array.logDescription())\(Log.getEmojis(level: level))"
        } else if let customString = object as? CustomStringConvertible {
            return "\(Log.getEmojis(level: level))\(customString.description)\(Log.getEmojis(level: level))"
        }
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

// MARK: - 解决字典及数组打印中文乱码
extension Optional: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "Optional(null)"
        case .some(let obj):
            if let customString = obj as? CustomStringConvertible {
                if let dict = customString as? [String: Any] {
                    return "Optional(\(dict.logDescription()))"
                } else if let array = customString as? [Any] {
                    return "Optional(\(array.logDescription()))"
                }
            }
            return "Optional(\(obj))"
        }
    }
}

extension Dictionary {
    /// 控制台打印内容，避免unicode编码乱码
    /// - Parameter level: 打印层级
    public func logDescription(level: Int = 0) -> String {
        var resultStr = ""
        var tab = ""
        for _ in 0..<level {
            tab.append(contentsOf: "\t")
        }
        resultStr.append(contentsOf: "{\n")
        for (key, value) in self {
            if let resultKey = key as? CVarArg {
                if let str = value as? String {
                    resultStr.append(contentsOf: String(format: "%@\t%@ = \"%@\",\n", tab, resultKey, str.unicodeStrWith(level)))
                } else if let dic = value as? [String: Any] {
                    resultStr.append(contentsOf: String(format: "%@\t%@ = %@,\n", tab, resultKey, dic.logDescription(level: level + 1)))
                } else if let array = value as? [Any] {
                    resultStr.append(contentsOf: String(format: "%@\t%@ = %@,\n", tab, resultKey, array.logDescription(level + 1)))
                } else {
                    resultStr.append(contentsOf: String(format: "%@\t%@ = %@,\n", tab, resultKey, "\(value)"))
                }
            }
        }
        resultStr.append(contentsOf: String(format: "%@}", tab))
        return resultStr
    }
}

extension Array {
    /// 控制台打印内容，避免unicode编码乱码
    /// - Parameter level: 打印层级
    public func logDescription(_ level: Int = 0) -> String {
        var resultStr = ""
        var tab = ""
        resultStr.append(contentsOf: "[\n")
        for _ in 0..<level {
            tab.append(contentsOf: "\t")
        }
        for value in self {
            if let str = value as? String {
                resultStr.append(contentsOf: String(format: "%@\t\"%@\",\n", tab, str.unicodeStrWith(level)))
            } else if let dict = value as? [String: Any] {
                resultStr.append(contentsOf: String(format: "%@\t%@,\n", tab, dict.logDescription(level: level + 1)))
            } else if let array = value as? [Any] {
                resultStr.append(contentsOf: String(format: "%@\t%@,\n", tab, array.logDescription(level + 1)))
            } else {
                resultStr.append(contentsOf: String(format: "%@\t%@,\n", tab, "\(value)"))
            }
        }
        resultStr.append(contentsOf: String(format: "%@]", tab))
        return resultStr
    }
}

extension String {
    func unicodeStrWith(_ level: Int = 0) -> String {
        if let data = self.data(using: .utf8) {
            if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                if let jsonArray = json as? [Any] {
                    return jsonArray.logDescription(level + 1)
                } else if let jsonDictionary = json as? [String: Any] {
                    return jsonDictionary.logDescription(level: level + 1)
                }
            }
        }
        let tempStr = self.replacingOccurrences(of: "\\u", with: "\\U").replacingOccurrences(of: "\"", with: "\\\"")
        let tempData = ("\"".appending(tempStr).appending("\"")).data(using: .utf8)
        var returnStr = ""
        do {
            returnStr = try (PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as? String ?? "")
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}
