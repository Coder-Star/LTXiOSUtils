//
//  LogUtil.swift
//  LTXiOSUtils
//  日志工具类
//  Created by 李天星 on 2019/11/21.
//

import Foundation

/// 日志工具类
open class LogUtil {

    /// 是否启动日志输出
    public static var enabled = false

    private init() {

    }

    /// 单例实体
    public static let shard = LogUtil()

    /// debug模式
    open  func d<T>(_ debug: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {

    }

    /// info模式
    open  func i<T>(_ info: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {

    }

    /// warning模式
    open  func w<T>(_ warning: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {

    }

    /// error模式
    open  func e<T>(_ error: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {

    }

}
