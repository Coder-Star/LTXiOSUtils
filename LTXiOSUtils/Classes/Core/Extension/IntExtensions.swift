//
//  IntExtensions.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/12/30.
//

import Foundation

extension Int: TxExtensionWrapperCompatibleValue {}

extension TxExtensionWrapper where Base == Int {

    /// 将int转为CGFloat
    public var cgFloatValue: CGFloat {
        return CGFloat(self.base)
    }
}
