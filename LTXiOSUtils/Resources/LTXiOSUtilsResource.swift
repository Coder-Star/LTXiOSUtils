//
//  LTXiOSUtilsResource.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/12/20.
//

import Foundation
import Localize_Swift

/// 资源工具类
public class LTXiOSUtilsResource {

    /// 获取基本Bundle
    public class func getBundle() -> String? {
        return Bundle.init(for: LTXiOSUtilsResource.self).path(forResource: "LTXiOSUtils", ofType: "bundle")
    }

    /// 获取城市地址信息
    public class func getAddress() -> String? {
        guard let bundlePath = getBundle() else {
            return nil
        }
        return Bundle(path: bundlePath)?.path(forResource: "Address", ofType: "plist")
    }
}

// MARK: - 字符串扩展，获取资源
public extension String {

    /// 获取LTXiOSUtils库中的国际化
    func localizedOfLTXiOSUtils() -> String {
        guard let bundlePath = LTXiOSUtilsResource.getBundle() else {
            return self
        }
        return localized(in: Bundle(path: bundlePath))
    }

    /// 获取LTXiOSUtils库中的图片
    func imageOfLTXiOSUtils() -> UIImage? {
        guard let bundlePath = LTXiOSUtilsResource.getBundle() else {
            return nil
        }
        return UIImage.init(named: self, in: Bundle(path: bundlePath), compatibleWith: nil)
    }
}
