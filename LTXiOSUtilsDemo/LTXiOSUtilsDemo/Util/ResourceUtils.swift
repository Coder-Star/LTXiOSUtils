//
//  ResourceUtils.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2020/2/3.
//

import Foundation
import SwiftyJSON

/// 文本资源类型
public enum TextResourceType {
    /// plist
    case plist
    /// json
    case json
}

/// 本地资源
public class ResourceUtils {

    /// 读取本地文本资源文件
    /// - Parameters:
    ///   - url: 文件地址
    ///   - type: 文件类型
    public class func getText(url: URL?, type: TextResourceType) -> JSON {
        var resultData = JSON()
        guard let fileUrl = url else {
            return resultData
        }
        switch type {
        case .plist:
            if let list = NSArray(contentsOf:fileUrl) {
                resultData = JSON(list)
            }
            if let dictionary = NSDictionary(contentsOf:fileUrl) {
                resultData = JSON(dictionary)
            }
        case .json:
            do {
                let data = try Data(contentsOf:fileUrl)
                resultData = JSON(data)
            } catch let error {
                Log.d(error)
            }
        }
        return resultData
    }
}
