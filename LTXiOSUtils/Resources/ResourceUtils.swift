//
//  ResourceUtils.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/12/20.
//

import Foundation
import Localize_Swift

/// 资源工具类
public class ResourceUtils {

    /// 获取基本Bundle
    public class func getBundle() -> String? {
        return Bundle.init(for: ResourceUtils.self).path(forResource: "LTXiOSUtils", ofType: "bundle")
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
        guard let bundlePath = ResourceUtils.getBundle() else {
            return self
        }
        return localized(in: Bundle(path: bundlePath))
    }
}
