//
//  UITabBarItem+BadgeView.swift
//  NCAppUIiOS
//
//  Created by CoderStar on 2020/1/12.
//

import UIKit

extension TxExtensionWrapper where Base: UITabBarItem {
    /// 通过Xcode视图调试工具找到UITabBarItem原生Badge所在父视图
    public var containerView: UIView {
        let tabBarButton = (base.value(forKey: "_view") as? UIView) ?? UIView()
        for subView in tabBarButton.subviews {
            guard let superclass = subView.superclass else { return tabBarButton }
            if superclass == NSClassFromString("UIImageView") {
                return subView
            }
        }
        return tabBarButton
    }
}
