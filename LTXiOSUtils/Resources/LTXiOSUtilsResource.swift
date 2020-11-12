//
//  LTXiOSUtilsResource.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/12/20.
//

import Foundation

// MARK: - 字符串扩展，获取资源
extension String {

    /// 获取LTXiOSUtils库中的国际化
    /// - Parameter comment: 注释参数
    public func localizedOfLTXiOSUtils(_ comment: String = "") -> String {
        return Bundle.getBundle(bundleName: "LTXiOSUtils")?.localizedString(forKey: self, value: "", table: nil) ?? ""
    }

    /// 获取LTXiOSUtils库中的图片
    public func imageOfLTXiOSUtils() -> UIImage? {
        return UIImage(named: self, in: Bundle.getBundle(bundleName: "LTXiOSUtils"), compatibleWith: nil)
    }
}
