//
//  CrashManager.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/10/12.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation

enum CrashPathEnum: String {
    case signalCrashPath = "SignaCrash"
    case nsExceptionCrashPath = "NSExceptionCrash"
}

// 请留意不要集成多个crash捕获，NSSetUncaughtExceptionHandler可能会被覆盖，NSException的crash也会同时生成一个signal异常信息
class CrashManager {

    static var crashLogFilePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending("/CrashLog")

    class func registerHandler() {
        CrashSignalManager.registerSignalHandler()
        CrashNSExceptionManager.registerUncaughtExceptionHandler()
    }

    // MARK: - 获取所有的log列表
    class func crashFileList(crashPathStr: CrashPathEnum) -> [String] {
        let crashPath = crashLogFilePath.appending("/\(crashPathStr.rawValue)")
        let fileManager = FileManager.default
        var logFiles = [String]()
        if let fileList = try? fileManager.contentsOfDirectory(atPath: crashPath) {
            for fileName in fileList {
                if fileName.range(of: ".log") != nil {
                    logFiles.append(crashPath + "/" + fileName)
                }
            }
        }
        return logFiles
    }

    // MARK: - 读取所有的崩溃信息
    class func readAllCrashInfo() -> [String] {
        var crashInfoArr = [String]()

        for signalPathStr in crashFileList(crashPathStr: .signalCrashPath) {
            if let content = try? String(contentsOfFile: signalPathStr, encoding: .utf8) {
                crashInfoArr.append(content)
            }
        }

        for exceptionPathStr in crashFileList(crashPathStr: .nsExceptionCrashPath) {
            if let content = try? String(contentsOfFile: exceptionPathStr, encoding: .utf8) {
                crashInfoArr.append(content)
            }
        }

        return crashInfoArr
    }

    // MARK: - 读取单个文件崩溃信息
    class func readCrash(crashPathStr: CrashPathEnum, fileName: String) -> String? {
        let filePath = crashLogFilePath.appending("/\(crashPathStr)").appending("/\(fileName)")
        let content = try? String(contentsOfFile: filePath, encoding: .utf8)
        return content
    }

    /// 保存Crash
    /// - Parameters:
    ///   - appendPathStr: 路径
    ///   - exceptionInfo: 错误信息
    class func saveCrash(appendPathStr: CrashPathEnum, exceptionInfo: String) {
        let filePath = crashLogFilePath.appending("/\(appendPathStr.rawValue)")
        if !FileManager.default.fileExists(atPath: filePath) {
            try? FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd-HHmmss"
        let dateString = dateFormatter.string(from: Date())
        let crashFilePath = filePath.appending("/\(dateString).log")
        try? exceptionInfo.write(toFile: crashFilePath, atomically: true, encoding: .utf8)
    }

}

extension CrashManager {
    // MARK: - 删除所有崩溃信息文件信息
    class func deleteAllCrashFile() {
        // 删除signal崩溃文件
        for signalPathStr in crashFileList(crashPathStr: .signalCrashPath) {
            try? FileManager.default.removeItem(atPath: signalPathStr)
        }
        // 删除NSexception崩溃文件
        for exceptionPathStr in crashFileList(crashPathStr: .nsExceptionCrashPath) {
            try? FileManager.default.removeItem(atPath: exceptionPathStr)
        }

    }

    // MARK: - 删除单个崩溃信息文件
    class func deleteCrash(crashPathStr: CrashPathEnum, fileName: String) {
        let filePath = crashLogFilePath.appending("/\(crashPathStr)").appending("/\(fileName)")
        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: filePath)
    }
}
