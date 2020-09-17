//
//  UILabelExtensions.swift
//  LTXiOSUtils
//  UILabel扩展
//  Created by 李天星 on 2020/1/2.
//

import Foundation

extension TxExtensionWrapper where Base: UILabel {

    /// UIlabel设置内容，当设置值为空时，改为赋值为空格
    /// 主要是为自动布局使用，避免设置值为空时，导致label高度较小
    public var content: String? {
        set {
            if let value = newValue, value.tx.isNotEmpty {
                self.base.text = value
            } else {
                self.base.text = " "
            }
        }
        get {
            return self.base.text
        }
    }

}
