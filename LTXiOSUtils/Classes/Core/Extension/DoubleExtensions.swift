//
//  DoubleExtensions.swift
//  LTXiOSUtils
//  Double扩展
//  Created by 李天星 on 2020/3/20.
//

import Foundation

extension Double: TxExtensionWrapperProtocol {}

extension TxExtensionWrapper where Base == Double {

    /// 去除浮点数后面多余的0
    public var removeSuffixZero: String {
        return self.base.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self.base) : String(self.base)
    }

}
