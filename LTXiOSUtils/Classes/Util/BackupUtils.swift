//
//  BackUpUtils.swift
//  LTXiOSUtils
//  备份相关工具类
//  Created by 李天星 on 2021/1/18.
//

import Foundation

/// 备份工具类
public struct BackupUtils {

    /// 设置跳过备份的文件路径
    /// - Parameter filePath: 文件路径
    /// - Throws: 设置过程中出现的Error
    public func addSkipBackupFilePath(filePath: String) throws {
        var excludeUrl = URL(fileURLWithPath: filePath)
        var urlResourceValues = URLResourceValues()
        urlResourceValues.isExcludedFromBackup = true
        try excludeUrl.setResourceValues(urlResourceValues)
    }
}
