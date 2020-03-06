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

    /// 提示框
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 内容
    ///   - cancel: 按钮
    func showAlert(title: String = "", message: String, cancel: String = "好的") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    /// 带回调功能的提示框
    /// - Parameters:
    ///   - style: 样式
    ///   - title: 标题
    ///   - message: 内容
    ///   - sureTitle: 确定按钮标题
    ///   - cancelTitle: 取消按钮标题，如为空则不显示
    ///   - sureBlock: 确定按钮闭包回调
    func showAlertWithCallBack(style: UIAlertController.Style = .alert, title: String = "", message: String, sureTitle: String = "确定", cancelTitle: String = "取消", sureBlock: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAciton = UIAlertAction(title: sureTitle, style: .default, handler: {_ in
            sureBlock()
        })
        if !cancelTitle.isEmpty {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
        alertController.addAction(okAciton)
        self.present(alertController, animated: true, completion: nil)
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
