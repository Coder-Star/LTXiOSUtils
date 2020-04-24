//
//  ResourceUtils.swift
//  LTXiOSUtils
//  本地资源操作工具类
//  Created by 李天星 on 2020/2/3.
//

import Foundation

/// 文本资源plist类型
public enum ResourcePlistType {
    /// 列表
    case arr
    /// 字典
    case dic
}

/// 文本资源类型
public enum ResourceType {
    /// plist
    case plist(type: ResourcePlistType)
    /// json
    case json
    /// 字符串
    case str
}

/// 本地资源
public struct ResourceUtils {

    /// 读取本地文本资源文件
    /// - Parameters:
    ///   - path: 文件路径
    ///   - type: 文件类型
    public static func getContentInfo(path: String?, type: ResourceType) -> Any? {
        var resultInfo: Any?
        guard let filePath = path else {
            return nil
        }
        switch type {
        case .plist(let type):
            switch type {
            case .arr:
                resultInfo = NSArray(contentsOfFile: filePath)
            case .dic:
                resultInfo = NSDictionary(contentsOfFile: filePath)
            }
        case .json:
            do {
                resultInfo = try Data(contentsOf: URL(fileURLWithPath: filePath))
            } catch let error {
                assert(false, error.localizedDescription)
            }
        case .str:
            do {
                resultInfo = try String(contentsOfFile: filePath)
            } catch let error {
                assert(false, error.localizedDescription)
            }
        }
        return resultInfo
    }
}
