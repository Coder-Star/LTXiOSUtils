//
//  ResourceUtils.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/12/20.
//

import Foundation
import Localize_Swift

private class ResourceUtils {

}

// MARK: - 字符串扩展，获取资源
public extension String {

    /// 获取LTXiOSUtils库中的国际化
    func localizedOfLTXiOSUtils() -> String {
        guard let bundlePath = Bundle.init(for: ResourceUtils.self).path(forResource: "LTXiOSUtils", ofType: "bundle") else {
            return self
        }
        return localized(in: Bundle(path: bundlePath))
    }
}
