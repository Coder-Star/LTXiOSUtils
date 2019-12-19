//
//  UIViewControllerExtensions.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/12/19.
//

import Foundation

public extension UIViewController {

    /// 获取当前屏幕当前ViewController
    /// - Parameter base: 基础UIViewController，默认为window的rootViewController
    class func current(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return current(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return current(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return current(base: presented)
        }
        return base
    }
}
