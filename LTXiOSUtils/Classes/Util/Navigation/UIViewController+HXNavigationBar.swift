//
//  UIViewController+HXNavigationBar.swift
//  HXNavigationController
//
//  Created by HongXiangWen on 2018/12/17.
//  Copyright © 2018年 WHX. All rights reserved.
//

import UIKit

// MARK: - 自定义导航栏相关的属性, 支持UINavigationBar.appearance()
extension UIViewController {

    // MARK: - 属性

    /// keys
    private struct HXNavigationBarKeys {
        static var barStyle = "HXNavigationBarKeys_barStyle"
        static var backgroundColor = "HXNavigationBarKeys_backgroundColor"
        static var backgroundImage = "HXNavigationBarKeys_backgroundImage"
        static var tintColor = "HXNavigationBarKeys_tintColor"
        static var barAlpha = "HXNavigationBarKeys_barAlpha"
        static var titleColor = "HXNavigationBarKeys_titleColor"
        static var titleFont = "HXNavigationBarKeys_titleFont"
        static var shadowHidden = "HXNavigationBarKeys_shadowHidden"
        static var shadowColor = "HXNavigationBarKeys_shadowColor"
        static var enablePopGesture = "HXNavigationBarKeys_enablePopGesture"
    }

    /// 导航栏样式，默认样式
    var navigationBarStyle: UIBarStyle {
        get {
            return objc_getAssociatedObject(self, &HXNavigationBarKeys.barStyle) as? UIBarStyle ?? UINavigationBar.appearance().barStyle
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.barStyle, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            hx_setNeedsNavigationBarTintUpdate()
        }
    }

    /// 导航栏前景色（item的文字图标颜色），默认黑色
    var navigationBarTintColor: UIColor {
        get {
            if let tintColor = objc_getAssociatedObject(self, &HXNavigationBarKeys.tintColor) as? UIColor {
                return tintColor
            }
            if let tintColor = UINavigationBar.appearance().tintColor {
                return tintColor
            }
            return .black
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.tintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            hx_setNeedsNavigationBarTintUpdate()
        }
    }

    /// 导航栏标题文字颜色，默认黑色
    var navigationBarTitleColor: UIColor {
        get {
            if let titleColor = objc_getAssociatedObject(self, &HXNavigationBarKeys.titleColor) as? UIColor {
                return titleColor
            }
            if let titleColor = UINavigationBar.appearance().titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor {
                return titleColor
            }
            return .black
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.titleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            hx_setNeedsNavigationBarTintUpdate()
        }
    }

    /// 导航栏标题文字字体，默认17号粗体
    var navigationBarTitleFont: UIFont {
        get {
            if let titleFont = objc_getAssociatedObject(self, &HXNavigationBarKeys.titleFont) as? UIFont {
                return titleFont
            }
            if let titleFont = UINavigationBar.appearance().titleTextAttributes?[NSAttributedString.Key.font] as? UIFont {
                return titleFont
            }
            return UIFont.boldSystemFont(ofSize: 17)
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.titleFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            hx_setNeedsNavigationBarTintUpdate()
        }
    }

    /// 导航栏背景色，默认白色
    var navigationBarBackgroundColor: UIColor {
        get {
            if let backgroundColor = objc_getAssociatedObject(self, &HXNavigationBarKeys.backgroundColor) as? UIColor {
                return backgroundColor
            }
            if let backgroundColor = UINavigationBar.appearance().barTintColor {
                return backgroundColor
            }
            return .white
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.backgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            hx_setNeedsNavigationBarBackgroundUpdate()
        }
    }

    /// 导航栏背景图片
    var navigationBarBackgroundImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &HXNavigationBarKeys.backgroundImage) as? UIImage ?? UINavigationBar.appearance().backgroundImage(for: .default)
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.backgroundImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            hx_setNeedsNavigationBarBackgroundUpdate()
        }
    }

    /// 导航栏背景透明度，默认1
    var navigationBarAlpha: CGFloat {
        get {
            return objc_getAssociatedObject(self, &HXNavigationBarKeys.barAlpha) as? CGFloat ?? 1
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.barAlpha, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            hx_setNeedsNavigationBarBackgroundUpdate()
        }
    }

    /// 导航栏底部分割线是否隐藏，默认不隐藏
    var navigationBarShadowHidden: Bool {
        get {
            return objc_getAssociatedObject(self, &HXNavigationBarKeys.shadowHidden) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.shadowHidden, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            hx_setNeedsNavigationBarShadowUpdate()
        }
    }

    /// 导航栏底部分割线颜色
    var navigationBarShadowColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &HXNavigationBarKeys.shadowColor) as? UIColor ?? UIColor(white: 0, alpha: 0.3)
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.shadowColor, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            hx_setNeedsNavigationBarShadowUpdate()
        }
    }

    /// 是否开启手势返回，默认开启
    var navigationBarEnablePopGesture: Bool {
        get {
            return objc_getAssociatedObject(self, &HXNavigationBarKeys.enablePopGesture) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &HXNavigationBarKeys.enablePopGesture, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    // MARK: - 更新UI

    // 整体更新
    func hx_setNeedsNavigationBarUpdate() {
        guard let naviController = navigationController as? HXNavigationController else { return }
        naviController.hx_updateNavigationBar(for: self)
    }

    // 更新文字、title颜色
    func hx_setNeedsNavigationBarTintUpdate() {
        guard let naviController = navigationController as? HXNavigationController else { return }
        naviController.hx_updateNavigationBarTint(for: self)
    }

    // 更新背景
    func hx_setNeedsNavigationBarBackgroundUpdate() {
        guard let naviController = navigationController as? HXNavigationController else { return }
        naviController.hx_updateNavigationBarBackground(for: self)
    }

    // 更新shadow
    func hx_setNeedsNavigationBarShadowUpdate() {
        guard let naviController = navigationController as? HXNavigationController else { return }
        naviController.hx_updateNavigationBarShadow(for: self)
    }

}
