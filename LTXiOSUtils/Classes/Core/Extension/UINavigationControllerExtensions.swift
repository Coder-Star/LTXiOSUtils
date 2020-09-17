//
//  UINavigationControllerExtensions.swift
//  LTXiOSUtils
//  UINavigationController扩展
//  Created by 李天星 on 2020/9/17.
//

import Foundation

extension UINavigationController {

    /// 关闭当前页面并跳转到新页面
    /// - Parameters:
    ///   - viewController: 页面
    ///   - animated: 是否显示动画
    public func toViewControllerAndCloseSelf(_ viewController: UIViewController, animated: Bool = true) {
        var newViewControllers = [UIViewController]()
        if viewControllers.count > 0 {
            for index in 0..<viewControllers.count - 1 {
                newViewControllers.append(viewControllers[index])
            }
        }
        newViewControllers.append(viewController)
        setViewControllers(newViewControllers, animated: animated)
    }
}
