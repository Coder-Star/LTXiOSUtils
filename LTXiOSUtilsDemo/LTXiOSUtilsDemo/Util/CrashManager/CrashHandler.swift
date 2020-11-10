//
//  CrashSignalManager.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/10/12.
//  Copyright © 2019年 李天星. All rights reserved.
//  用于搜集Signal异常导致的崩溃

import UIKit

/// Crash类型
public enum CrashHandlerType: String {
    case signal
    case exception
}

/// Crash信息实体
public struct CrashInfoModel {
    var type: CrashHandlerType?
    var name = ""
    var reason = ""
    var callStack = ""
}

/// CrashHandler代理
public protocol CrashHandlerDelegate {
    // swiftlint:disable:previous class_delegate_protocol
    /// 捕获到异常
    func didCatchCarsh(carshInfo: CrashInfoModel)
}

/// Crash异常捕获
public struct CrashHandler {
    /// 是否开启
    public static var enabled = false {
        didSet {
            if enabled {
                openSignalHandler()
                openExceptionHandler()
            } else {
                closeSignalHandler()
                closeExceptionHandler()
            }
        }
    }

    /// delegate
    static var delegate: CrashHandlerDelegate?
}

// MARK: - Signal信号异常捕获
extension CrashHandler {

    private static func openSignalHandler() {
        /**
         1.具有nil值的非可选类型
         2.一个失败的强制类型转换
         */
        signal(SIGTRAP, CrashHandler.signalHandler)

        signal(SIGABRT, CrashHandler.signalHandler)
        signal(SIGSEGV, CrashHandler.signalHandler)
        signal(SIGBUS, CrashHandler.signalHandler)
        signal(SIGILL, CrashHandler.signalHandler)

        //    signal(SIGHUP, SignalExceptionHandler)
        //    signal(SIGINT, SignalExceptionHandler)
        //    signal(SIGQUIT, SignalExceptionHandler)
        //    signal(SIGFPE, SignalExceptionHandler)
        //    signal(SIGPIPE, SignalExceptionHandler)
    }

    private static func closeSignalHandler() {
        signal(SIGINT, SIG_DFL)
        signal(SIGSEGV, SIG_DFL)
        signal(SIGTRAP, SIG_DFL)
        signal(SIGABRT, SIG_DFL)
        signal(SIGILL, SIG_DFL)
    }

    private static let signalHandler: @convention(c) (Int32) -> Void = { signal in
        var callStack = "Stack:\n"
        // 获取偏移量地址
        callStack = callStack.appendingFormat("slideAdress:0x%0x\r\n", SlideAdressTool.calculate())
        // 增加错误信息
        for symbol in Thread.callStackSymbols {
            callStack = callStack.appendingFormat("%@\r\n", symbol)
        }
        let name = signalName(of: signal)
        let reason = "Signal \(name) was raised.\n"
        let crashInfo = CrashInfoModel(type: .signal, name: name, reason: reason, callStack: callStack)
        delegate?.didCatchCarsh(carshInfo: crashInfo)
        exit(signal)

    }

    private static func signalName(of signal: Int32) -> String {
        switch signal {
        case SIGABRT:
            return "SIGABRT"
        case SIGILL:
            return "SIGILL"
        case SIGSEGV:
            return "SIGSEGV"
        case SIGFPE:
            return "SIGFPE"
        case SIGBUS:
            return "SIGBUS"
        case SIGPIPE:
            return "SIGPIPE"
        default:
            return "OTHER"
        }
    }
}

// MARK: - NSException异常捕获
// NSException一般只在OC当中捕获，一般情况下捕获NSException异常后同时也会捕获一个对应的signal异常
extension CrashHandler {

    private static func openExceptionHandler() {
        NSSetUncaughtExceptionHandler(CrashHandler.exceptionHandler)
    }

    private static func closeExceptionHandler() {
        NSSetUncaughtExceptionHandler(nil)
    }

    private static let exceptionHandler: @convention(c) (NSException) -> Void = { exception in
        let arr = exception.callStackSymbols
        let reason = exception.reason
        let name = exception.name.rawValue
        var callStack = "Stack:\n"
        callStack = callStack.appendingFormat("slideAdress:0x%0x\r\n", SlideAdressTool.calculate())
        callStack += "name:\(name) \n reason:\(String(describing: reason)) \n \(arr.joined(separator: "\r\n"))"
        let crashInfo = CrashInfoModel(type: .exception, name: exception.name.rawValue, reason: exception.reason ?? "", callStack: callStack)
        delegate?.didCatchCarsh(carshInfo: crashInfo)
    }

}
