//
//  IntExtensions.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2019/12/30.
//

import Foundation
import UIKit

extension Int: TxExtensionWrapperCompatibleValue {}

extension TxExtensionWrapper where Base == Int {
    /// 将int转为CGFloat
    public var cgFloatValue: CGFloat {
        return CGFloat(base)
    }
}
