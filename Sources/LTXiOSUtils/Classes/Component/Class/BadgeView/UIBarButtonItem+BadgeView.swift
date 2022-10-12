//
//  UIBarButtonItem+BadgeView.swift
//  NCAppUIiOS
//
//  Created by CoderStar on 2020/1/12.
//

import UIKit

extension TxExtensionWrapper where Base: UIBarButtonItem {
    /// 通过Xcode视图调试工具找到UIBarButtonItem的Badge所在父视图为:UIImageView
    public var badgeContainerView: UIView {
        let navigationButton = (base.value(forKey: "_view") as? UIView) ?? UIView()
        let systemVersion = (UIDevice.current.systemVersion as NSString).doubleValue
        let controlName = systemVersion < 11.0 ? "UIImageView" : "UIButton"
        for subView in navigationButton.subviews {
            if subView.isKind(of: NSClassFromString(controlName)!) {
                subView.layer.masksToBounds = false
                return subView
            }
        }
        return navigationButton
    }
}
