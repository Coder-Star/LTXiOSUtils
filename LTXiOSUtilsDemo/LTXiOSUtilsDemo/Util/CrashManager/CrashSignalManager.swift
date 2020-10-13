//
//  CrashSignalManager.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/10/12.
//  Copyright © 2019年 李天星. All rights reserved.
//  用于搜集Signal异常导致的崩溃(包括Swift及OC)

import UIKit

class CrashSignalManager {

    class func registerSignalHandler() {

        //    如果在运行时遇到意外情况，Swift代码将以SIGTRAP此异常类型终止，例如：
        //    1.具有nil值的非可选类型
        //    2.一个失败的强制类型转换
        //    查看Backtraces以确定遇到意外情况的位置。附加信息也可能已被记录到设备的控制台。您应该修改崩溃位置的代码，以正常处理运行时故障。例如，使用可选绑定而不是强制解开可选的。

        signal(SIGABRT, signalExceptionHandler)
        signal(SIGSEGV, signalExceptionHandler)
        signal(SIGBUS, signalExceptionHandler)
        signal(SIGTRAP, signalExceptionHandler)
        signal(SIGILL, signalExceptionHandler)

        //    signal(SIGHUP, SignalExceptionHandler)
        //    signal(SIGINT, SignalExceptionHandler)
        //    signal(SIGQUIT, SignalExceptionHandler)
        //    signal(SIGFPE, SignalExceptionHandler)
        //    signal(SIGPIPE, SignalExceptionHandler)

    }

    func unregisterSignalHandler() {
        signal(SIGINT, SIG_DFL)
        signal(SIGSEGV, SIG_DFL)
        signal(SIGTRAP, SIG_DFL)
        signal(SIGABRT, SIG_DFL)
        signal(SIGILL, SIG_DFL)
    }
}

func signalExceptionHandler(signal: Int32) {
    var mstr = String()
    mstr += "Stack:\n"
    // 获取偏移量地址
    mstr = mstr.appendingFormat("slideAdress:0x%0x\r\n", calculate())
    // 增加错误信息
    for symbol in Thread.callStackSymbols {
        mstr = mstr.appendingFormat("%@\r\n", symbol)
    }
    CrashManager.saveCrash(appendPathStr: .signalCrashPath, exceptionInfo: mstr)
    exit(signal)
}
