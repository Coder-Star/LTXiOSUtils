//
//  BundleExtension.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2020/11/9.
//

import Foundation

extension TxExtensionWrapper where Base: Bundle {
    /// 获取指定pod的指定Bundle，pod以resource_bundle方式引入资源
    /// - Parameters:
    ///   - bundleName: bundleName
    ///   - podName: podName,当使用framwork时使用，如果为nil，赋值为bundleName
    /// - Note: 当使用framework方式引用三方库时，每一个三方库都会在Frameworks下面以一个单独的framework存在
    public static func getBundle(bundleName: String, podName: String? = nil) -> Bundle? {
        var podNameStr = podName
        var bundleNameStr = bundleName
        if bundleNameStr.contains(".bundle") {
            bundleNameStr = bundleNameStr.components(separatedBy: ".bundle").first!
        }
        // 不使用framwork
        var url = Bundle.main.url(forResource: bundleNameStr, withExtension: "bundle")
        // 使用framwork,拼接路径
        if url == nil {
            if podNameStr == nil {
                podNameStr = bundleNameStr
            }
            url = Bundle.main.url(forResource: "Frameworks", withExtension: nil)
            url = url?.appendingPathComponent(podNameStr!).appendingPathExtension("framework")
            if url == nil {
                return nil
            }
            url = Bundle(url: url!)?.url(forResource: bundleNameStr, withExtension: "bundle")
        }
        guard let bundleUrl = url else {
            return nil
        }
        return Bundle(url: bundleUrl)
    }
}
