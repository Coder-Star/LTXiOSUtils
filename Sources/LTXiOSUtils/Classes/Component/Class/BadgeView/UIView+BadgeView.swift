//
//  UIView+BadgeView.swift
//  NCAppUIiOS
//
//  Created by CoderStar on 2020/1/12.
//

import UIKit

/// 调用方法的View不可对自己进行裁切，会导致角标也被裁切掉

/// 徽标类型
public enum BadgeType {
    /// 无点
    case none
    /// 文字
    case text(value: String)
    /// 数字
    case number(value: Int)
    /// 点
    case dot
}

extension TxExtensionWrapper where Base: UIView {
    public func set(type: BadgeType) {
        switch type {
        case let .text(value):
            updateBadgeStyle(text: value)
            set(height: BadgeSizeConfig.defaultBadgeHeight)
            base.badgeView.isHidden = false
        case let .number(value):
            updateBadgeStyle(text: "\(value)")
            set(height: BadgeSizeConfig.defaultBadgeHeight)
            base.badgeView.isHidden = false
        case .dot:
            updateBadgeStyle(text: nil)
            set(height: BadgeSizeConfig.defaultDotSize)
            base.badgeView.isHidden = false
        case .none:
            base.badgeView.isHidden = true
        }
    }

    /// 角标view
    public var badgeView: BadgeControl {
        return base.badgeView
    }

    /// 设置Badge伸缩的方向
    ///
    /// - Parameter flexMode : 伸缩方向，默认为  tail
    public func set(flexMode: BadgeViewFlexMode = .tail) {
        base.badgeView.flexMode = flexMode
        move(x: base.badgeView.offset.x, y: base.badgeView.offset.y)
    }

    /// 设置Badge的高度,因为Badge宽度是动态可变的,通过改变Badge高度,其宽度也按比例变化,方便布局
    /// (注意: 此方法需要将Badge添加到控件上后再调用!!!)
    ///
    /// - Parameter height: 高度大小
    public func set(height: CGFloat) {
        base.badgeView.heightConstraint()?.constant = height
        base.badgeView.layer.cornerRadius = height * 0.5
        move(x: base.badgeView.offset.x, y: base.badgeView.offset.y)
    }

    /// 设置Badge的偏移量, Badge中心点默认为其父视图的右上角
    ///
    /// - Parameters:
    ///   - x: X轴偏移量 (x<0: 左移, x>0: 右移)
    ///   - y: Y轴偏移量 (y<0: 上移, y>0: 下移)
    public func move(x: CGFloat, y: CGFloat) {
        base.badgeView.offset = CGPoint(x: x, y: y)
        base.centerYConstraint(with: base.badgeView)?.constant = y

        let badgeHeight = base.badgeView.heightConstraint()?.constant ?? 0
        switch base.badgeView.flexMode {
        case .head:
            base.centerXConstraint(with: base.badgeView)?.isActive = false
            base.leadingConstraint(with: base.badgeView)?.isActive = false
            if let constraint = base.trailingConstraint(with: base.badgeView) {
                constraint.constant = badgeHeight * 0.5 + x
                return
            }
            let trailingConstraint = NSLayoutConstraint(item: base.badgeView, attribute: .trailing, relatedBy: .equal, toItem: base, attribute: .trailing, multiplier: 1.0, constant: badgeHeight * 0.5 + x)
            base.addConstraint(trailingConstraint)

        case .tail:
            base.centerXConstraint(with: base.badgeView)?.isActive = false
            base.trailingConstraint(with: base.badgeView)?.isActive = false
            if let constraint = base.leadingConstraint(with: base.badgeView) {
                constraint.constant = x - badgeHeight * 0.5
                return
            }
            let leadingConstraint = NSLayoutConstraint(item: base.badgeView, attribute: .leading, relatedBy: .equal, toItem: base, attribute: .trailing, multiplier: 1.0, constant: x - badgeHeight * 0.5)
            base.addConstraint(leadingConstraint)

        case .middle:
            base.leadingConstraint(with: base.badgeView)?.isActive = false
            base.trailingConstraint(with: base.badgeView)?.isActive = false
            base.centerXConstraint(with: base.badgeView)?.constant = x
            if let constraint = base.centerXConstraint(with: base.badgeView) {
                constraint.constant = x
                return
            }
            let centerXConstraint = NSLayoutConstraint(item: base.badgeView, attribute: .centerX, relatedBy: .equal, toItem: base, attribute: .centerX, multiplier: 1.0, constant: x)
            base.addConstraint(centerXConstraint)
        }
    }

    private func updateBadgeStyle(text: String?) {
        base.badgeView.text = text
        set(flexMode: base.badgeView.flexMode)
        if text == nil {
            if base.badgeView.widthConstraint()?.relation == .equal { return }
            base.badgeView.widthConstraint()?.isActive = false
            let constraint = NSLayoutConstraint(item: base.badgeView, attribute: .width, relatedBy: .equal, toItem: base.badgeView, attribute: .height, multiplier: 1.0, constant: 0)
            base.badgeView.addConstraint(constraint)
        } else {
            if base.badgeView.widthConstraint()?.relation == .greaterThanOrEqual { return }
            base.badgeView.widthConstraint()?.isActive = false
            let constraint = NSLayoutConstraint(item: base.badgeView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: base.badgeView, attribute: .height, multiplier: 1.0, constant: 0)
            base.badgeView.addConstraint(constraint)
        }
    }
}

// MARK: - View扩展

extension UIView {
    private struct UIViewAssociatedKeyBadgeView {
        static var key: Void?
    }

    /// 角标view
    var badgeView: BadgeControl {
        get {
            if let aValue = objc_getAssociatedObject(self, &UIViewAssociatedKeyBadgeView.key) as? BadgeControl {
                return aValue
            } else {
                let badgeControl = BadgeControl()
                addSubview(badgeControl)
                bringSubviewToFront(badgeControl)
                badgeView = badgeControl
                addBadgeViewLayoutConstraint()
                return badgeControl
            }
        }
        set {
            objc_setAssociatedObject(self, &UIViewAssociatedKeyBadgeView.key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private func addBadgeViewLayoutConstraint() {
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        let centerXConstraint = NSLayoutConstraint(item: badgeView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: badgeView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: badgeView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: badgeView, attribute: .height, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: badgeView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: BadgeSizeConfig.defaultBadgeHeight)
        addConstraints([centerXConstraint, centerYConstraint])
        badgeView.addConstraints([widthConstraint, heightConstraint])
        badgeView.layer.cornerRadius = BadgeSizeConfig.defaultBadgeHeight / 2
    }

    func topConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .top)
    }

    func leadingConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .leading)
    }

    func bottomConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .bottom)
    }

    func trailingConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .trailing)
    }

    func widthConstraint() -> NSLayoutConstraint? {
        return constraint(with: self, attribute: .width)
    }

    func heightConstraint() -> NSLayoutConstraint? {
        return constraint(with: self, attribute: .height)
    }

    func centerXConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .centerX)
    }

    func centerYConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .centerY)
    }

    private func constraint(with item: AnyObject?, attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        for constraint in constraints {
            if let isSame = constraint.firstItem?.isEqual(item), isSame, constraint.firstAttribute == attribute {
                return constraint
            }
        }
        return nil
    }
}
