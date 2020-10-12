//
//  TempUtils.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/3/17.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class TempUtils {
    static func getMimeType(pathExtension: String) -> String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        // 文件资源类型如果不知道，传万能类型application/octet-stream，服务器会自动解析文件类
        return "application/octet-stream"
    }
}
