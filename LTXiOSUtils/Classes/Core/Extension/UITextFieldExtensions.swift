//
//  UITextFieldExtensions.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2020/9/28.
//

import Foundation
import UIKit

extension TxExtensionWrapper where Base: UITextField {
    /// 取值时去除了空格符以及换行符
    /// 可用于提交表单前用来判断值是否不为空
    public var contentText: String? {
        set {
            self.base.text = newValue
        }
        get {
            return self.base.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}


@IBDesignable
extension UITextField {

    @IBInspectable
    public var csLeftPaddingWidth: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }

    @IBInspectable
    public var csRigthPaddingWidth: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
}
