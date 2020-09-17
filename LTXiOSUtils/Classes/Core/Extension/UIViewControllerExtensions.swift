//
//  UIViewControllerExtensions.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/12/19.
//

import Foundation

extension TxExtensionWrapper where Base: UIViewController {

    /// 获取当前屏幕顶层ViewController
    /// - Parameter base: 基础UIViewController，默认为window的rootViewController
    public static func topViewController(of base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let presented = base?.presentedViewController {
            return topViewController(of: presented)
        }
        if let nav = base as? UINavigationController {
            return topViewController(of: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topViewController(of: tab.selectedViewController)
        }
        if let page = base as? UIPageViewController, page.viewControllers?.count == 1 {
            return topViewController(of: page.viewControllers?.first)
        }
        for subview in base?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return topViewController(of: childViewController)
            }
        }
        return base
    }

    /// 是否可见
    public var isVisible: Bool {
        return self.base.isViewLoaded && self.base.view.window != nil
    }

    /// 删除所有子ViewController
    public func removeAllChildren() {
        self.base.children.forEach {
            $0.removeFromParent()
        }
    }

    /// dimiss所有的presentedViewController
    /// - Parameters:
    ///   - animated: 是否显示动画
    ///   - completion: 完成dismiss闭包回调
    public func dismissToRootViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        var tempPresentingViewController = self.base
        while let viewController = self.base.presentingViewController as? Base {
            tempPresentingViewController = viewController
        }
        tempPresentingViewController.dismiss(animated: animated, completion: completion)
    }

}

extension UIViewController {

    /// 生成提示框，一个按钮回调
    /// - Parameters:
    ///   - style: 样式
    ///   - title: 标题
    ///   - message: 消息
    ///   - cancelTitle: 按钮标题
    ///   - sureBlock: 按钮闭包
    public func getAlert(style: UIAlertController.Style = .alert,
                  title: String = "",
                  message: String,
                  cancelTitle: String = "好的",
                  sureBlock: (() -> Void)? = nil) -> UIAlertController? {

        if title.isEmpty, message.isEmpty {
            return nil
        }
        if cancelTitle.isEmpty {
            return nil
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            sureBlock?()
        }
        alertController.addAction(cancelAction)
        return alertController
    }

    /// 显示提示框，一个按钮回调
    /// - Parameters:
    ///   - style: 样式
    ///   - title: 标题
    ///   - message: 消息
    ///   - cancelTitle: 按钮标题
    ///   - sureBlock: 按钮闭包
    public func showAlert(style: UIAlertController.Style = .alert,
                   title: String = "",
                   message: String,
                   cancelTitle: String = "好的",
                   sureBlock: (() -> Void)? = nil) {

        if let alertController = getAlert(style: style, title: title, message: message, cancelTitle: cancelTitle, sureBlock: sureBlock) {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    /// 生成提示框，两个按钮回调
    /// - Parameters:
    ///   - style: 样式
    ///   - title: 标题
    ///   - message: 内容
    ///   - sureTitle: 确定按钮标题
    ///   - cancelTitle: 取消按钮
    ///   - sureBlock: 确定按钮闭包回调
    ///   - cancelBlock: 取消按钮闭包回调
    public func getAlert(style: UIAlertController.Style = .alert,
                  title: String = "",
                  message: String,
                  sureTitle: String = "确定",
                  cancelTitle: String = "取消",
                  cancelBlock: (() -> Void)? = nil,
                  sureBlock: @escaping () -> Void) -> UIAlertController? {

        if title.isEmpty, message.isEmpty {
            return nil
        }
        if sureTitle.isEmpty || cancelTitle.isEmpty {
            return nil
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let sureAciton = UIAlertAction(title: sureTitle, style: .destructive) { _ in
            sureBlock()
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelBlock?()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(sureAciton)
        return alertController
    }

    /// 显示提示框，两个按钮回调
    /// - Parameters:
    ///   - style: 样式
    ///   - title: 标题
    ///   - message: 内容
    ///   - sureTitle: 确定按钮标题
    ///   - cancelTitle: 取消按钮
    ///   - sureBlock: 确定按钮闭包回调
    ///   - cancelBlock: 取消按钮闭包回调
    public func showAlert(style: UIAlertController.Style = .alert,
                   title: String = "",
                   message: String,
                   sureTitle: String = "确定",
                   cancelTitle: String = "取消",
                   cancelBlock: (() -> Void)? = nil,
                   sureBlock: @escaping () -> Void) {

        if let alertController = getAlert(style: style, title: title, message: message, sureTitle: sureTitle, cancelTitle: cancelTitle, cancelBlock: cancelBlock, sureBlock: sureBlock) {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension UIViewController {

    /// 点击空白处取消键盘
    public func hideKeyboardWhenTappedAround() {
        self.view.addTapGesture { tap in
            tap.cancelsTouchesInView = false
            self.view.endEditing(true)
        }
    }
}
