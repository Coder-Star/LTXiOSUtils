//
//  LTXiOSUtilsResource.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2019/12/20.
//

import Foundation
import UIKit
#if SWIFT_PACKAGE
import LTXiOSUtilsExtension
#endif

private let ltxiOSUtilsComponentBundle: Bundle = {
#if SWIFT_PACKAGE
    return Bundle.module
#else
    return Bundle.tx.getBundle(bundleName: "LTXiOSUtilsComponent") ?? Bundle.main
#endif
}()

// MARK: - 字符串扩展，获取资源

extension String {
    /// 获取LTXiOSUtilsComponent Bundle中的国际化
    /// - Parameter comment: 注释参数
    public var localizedOfLTXiOSUtilsComponent: String {
        return ltxiOSUtilsComponentBundle.localizedString(forKey: self, value: nil, table: nil)
    }

    /// 获取LTXiOSUtilsComponent Bundle库中的图片
    public var imageOfLTXiOSUtilsComponent: UIImage? {
        return UIImage(named: self, in: ltxiOSUtilsComponentBundle, compatibleWith: nil)
    }
}
