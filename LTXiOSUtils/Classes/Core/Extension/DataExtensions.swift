//
//  DataExtensions.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2020/9/30.
//

import Foundation

extension TxExtensionWrapper where Base == Data {
    /// 16进制Data转字符串
    ///
    /// - Note: 获取的推送token可以用这个进行转换
    public var hexString: String {
        return base.map { String(format: "%02x", $0) }.joined()
    }
}
