//
//  CSPaddingLabel.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/6/9.
//

import Foundation
import UIKit

/**
 使用时可不使用高度和宽度约束，如果想使用，高度及宽度应设置文字宽高度+padding值，
 如文字宽度是20，leftInset是5，rightInset是5，则宽度约束应设置为20 + 5 + 5
 */

@IBDesignable
open class CSPaddingLabel: UILabel {
    @IBInspectable
    open var topInset: CGFloat = 0.0

    @IBInspectable
    open var bottomInset: CGFloat = 0.0

    @IBInspectable
    open var leftInset: CGFloat = 0.0

    @IBInspectable
    open var rightInset: CGFloat = 0.0

    @IBInspectable
    open var edgeInsets: UIEdgeInsets {
        set {
            topInset = newValue.top
            bottomInset = newValue.bottom
            leftInset = newValue.left
            rightInset = newValue.right
        }
        get {
            return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        }
    }

    open override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = super.sizeThatFits(size)
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
}
