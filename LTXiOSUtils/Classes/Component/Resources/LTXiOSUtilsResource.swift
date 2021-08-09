//
//  LTXiOSUtilsResource.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2019/12/20.
//

import Foundation

// MARK: - 字符串扩展，获取资源

extension String {
    /// 获取LTXiOSUtilsComponent Bundle中的国际化
    /// - Parameter comment: 注释参数
    public var localizedOfLTXiOSUtilsComponent: String {
        return Bundle.getBundle(bundleName: "LTXiOSUtilsComponent")?.localizedString(forKey: self, value: nil, table: nil) ?? ""
    }

    /// 获取LTXiOSUtilsComponent Bundle库中的图片
    public var imageOfLTXiOSUtilsComponent: UIImage? {
        return UIImage(named: self, in: Bundle.getBundle(bundleName: "LTXiOSUtilsComponent"), compatibleWith: nil)
    }
}
