//
//  LTXiOSUtilsResource.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/12/20.
//

import Foundation

// MARK: - 字符串扩展，获取资源
public extension String {

    /// 获取LTXiOSUtils库中的国际化
    /// - Parameter comment: 注释参数
    func localizedOfLTXiOSUtils(_ comment: String = "") -> String {
        return ResourceUtils.getBundle(bundleName: "LTXiOSUtils")?.localizedString(forKey: self, value: "", table: nil) ?? ""
//        return localized(in: ResourceUtils.getBundle(bundleName: "LTXiOSUtils"))
    }

    /// 获取LTXiOSUtils库中的图片
    func imageOfLTXiOSUtils() -> UIImage? {
        return UIImage(named: self, in: ResourceUtils.getBundle(bundleName: "LTXiOSUtils"), compatibleWith: nil)
    }
}
