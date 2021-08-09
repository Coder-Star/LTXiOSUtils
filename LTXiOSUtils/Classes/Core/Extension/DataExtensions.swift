//
//  DataExtensions.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2020/9/30.
//

import Foundation

extension Data {
    /// 16进制Data转字符串
    public var hexString: String {
        return map { String(format: "%02x", $0) }.joined()
    }
}
