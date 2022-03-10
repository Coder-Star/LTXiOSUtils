//
//  UICollectionViewCellExtensions.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/9/12.
//

import Foundation
import UIKit

extension TxExtensionWrapper where Base: UICollectionViewCell {
    /// 标识符
    ///
    /// - Note: 重用时可使用
    public var identifier: String {
        return String(describing: base)
    }
}
