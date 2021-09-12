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
