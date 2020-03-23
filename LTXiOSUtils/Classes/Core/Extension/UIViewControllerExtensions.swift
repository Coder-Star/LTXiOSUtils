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

    /// 删除所有子ViewController
    func removeAllChildren() {
        self.children.forEach {
            $0.removeFromParent()
        }
    }

    /// dimiss所有的presentedViewController
    /// - Parameters:
    ///   - animated: 是否显示动画
    ///   - completion: 完成dismiss闭包回调
    func dismissToRootViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        var tempPresentingViewController = self
        while let viewController = self.presentingViewController {
            tempPresentingViewController = viewController
        }
        tempPresentingViewController.dismiss(animated: animated, completion: completion)
    }

}

public extension UIViewController {
    /// 显示提示框，可自动消失
    /// - Parameters:
    ///   - message: 显示内容
    ///   - time: 延时时间
    func showToast(_ message: String, delayTime: Double = 1.0) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.delay(delayTime) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }

    /// 生成提示框，一个按钮回调
    /// - Parameters:
    ///   - style: 样式
    ///   - title: 标题
    ///   - message: 消息
    ///   - cancelTitle: 按钮标题
    ///   - sureBlock: 按钮闭包
    func getAlert(style: UIAlertController.Style = .alert,
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
    func showAlert(style: UIAlertController.Style = .alert,
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
    func getAlert(style: UIAlertController.Style = .alert,
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
    func showAlert(style: UIAlertController.Style = .alert,
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

public extension UIViewController {

    /// 点击空白处取消键盘
    func hideKeyboardWhenTappedAround() {
        self.view.addTapGesture { tap in
            tap.cancelsTouchesInView = false
            self.view.endEditing(true)
        }
    }
}
