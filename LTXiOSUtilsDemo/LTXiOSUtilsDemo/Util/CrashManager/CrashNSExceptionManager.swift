//
//  CrashNSExceptionManager.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/10/12.
//  Copyright © 2019年 李天星. All rights reserved.
//  用于捕获OC的NSException导致的异常崩溃

import UIKit

class CrashNSExceptionManager {

    class func registerUncaughtExceptionHandler() {
        NSSetUncaughtExceptionHandler(uncaughtExceptionHandler)
    }

}

func uncaughtExceptionHandler(exception: NSException) {
    let arr = exception.callStackSymbols
    let reason = exception.reason
    let name = exception.name.rawValue
    var crash = String()
    crash += "Stack:\n"
    crash = crash.appendingFormat("slideAdress:0x%0x\r\n", calculate())
    crash += "\r\n\r\n name:\(name) \r\n reason:\(String(describing: reason)) \r\n \(arr.joined(separator: "\r\n")) \r\n\r\n"

    CrashManager.saveCrash(appendPathStr: .nsExceptionCrashPath, exceptionInfo: crash)
}
