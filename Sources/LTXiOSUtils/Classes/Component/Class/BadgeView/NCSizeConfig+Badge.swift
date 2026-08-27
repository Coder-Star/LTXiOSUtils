//
//  NCSizeConfig+Badge.swift
//  NCAppUIiOS
//
//  Created by CoderStar on 2022/10/12.
//

import Foundation
import UIKit
#if SWIFT_PACKAGE
import LTXiOSUtilsExtension
import LTXiOSUtilsUtil
#endif

/// 徽标相关尺寸
public struct BadgeSizeConfig {
    /// 徽标默认高度
    public static var defaultBadgeHeight: CGFloat = 16

    /// 点默认尺寸
    public static var defaultDotSize: CGFloat = 8
}
