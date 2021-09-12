//
//  UINavigationControllerExtensions.swift
//  LTXiOSUtils
//  UINavigationController扩展
//  Created by CoderStar on 2020/9/17.
//

import Foundation
import UIKit

extension TxExtensionWrapper where Base: UINavigationController {
    /// 关闭当前页面并跳转到新页面
    /// - Parameters:
    ///   - viewController: 页面
    ///   - animated: 是否显示动画
    public func toViewControllerAndCloseSelf(_ viewController: UIViewController, animated: Bool = true) {
        var newViewControllers = [UIViewController]()
        if base.viewControllers.count > 0 {
            for index in 0 ..< base.viewControllers.count - 1 {
                newViewControllers.append(base.viewControllers[index])
            }
        }
        newViewControllers.append(viewController)
        base.setViewControllers(newViewControllers, animated: animated)
    }
}
