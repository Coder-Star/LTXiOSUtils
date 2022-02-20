//
//  UIBarButtonItem+BadgeView.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2020/1/12.
//

import UIKit

extension TxExtensionWrapper where Base: UIBarButtonItem {
    /// 角标view
    public var badgeView: BadgeControl {
        return _bottomView.tx.badgeView
    }

    /// 添加带文本内容的Badge, 默认右上角, 红色, 18pts
    ///
    /// Add Badge with text content, the default utxer right corner, red backgroundColor, 18pts
    ///
    /// - Parameter text: 文本字符串
    public func addBadge(text: String) {
        _bottomView.tx.addBadge(text: text)
    }

    /// 添加带数字的Badge, 默认右上角,红色,18pts
    ///
    /// Add the Badge with numbers, the default utxer right corner, red backgroundColor, 18pts
    ///
    /// - Parameter number: 整形数字
    public func addBadge(number: Int) {
        _bottomView.tx.addBadge(number: number)
    }

    /// 添加带颜色的小圆点, 默认右上角, 红色, 8pts
    ///
    /// Add small dots with color, the default utxer right corner, red backgroundColor, 8pts
    ///
    /// - Parameter color: 颜色
    public func addDot(color: UIColor? = .red) {
        _bottomView.tx.addDot(color: color)
    }

    /// 设置Badge的偏移量, Badge中心点默认为其父视图的右上角
    ///
    /// Set Badge offset, Badge center point defaults to the top right corner of its parent view
    ///
    /// - Parameters:
    ///   - x: X轴偏移量 (x<0: 左移, x>0: 右移) axis offset (x <0: left, x> 0: right)
    ///   - y: Y轴偏移量 (y<0: 上移, y>0: 下移) axis offset (Y <0: up,   y> 0: down)
    public func moveBadge(x: CGFloat, y: CGFloat) {
        _bottomView.tx.moveBadge(x: x, y: y)
    }

    /// 设置Badge伸缩的方向
    ///
    /// Setting the direction of Badge expansion
    ///
    /// txBadgeViewFlexModeHead,    左伸缩 Head Flex    : <==●
    /// txBadgeViewFlexModeTail,    右伸缩 Tail Flex    : ●==>
    /// txBadgeViewFlexModeMiddle   左右伸缩 Middle Flex : <=●=>
    /// - Parameter flexMode : Default is txBadgeViewFlexModeTail
    public func setBadge(flexMode: BadgeViewFlexMode = .tail) {
        _bottomView.tx.setBadge(flexMode: flexMode)
    }

    /// 设置Badge的高度,因为Badge宽度是动态可变的,通过改变Badge高度,其宽度也按比例变化,方便布局
    ///
    /// (注意: 此方法需要将Badge添加到控件上后再调用!!!)
    ///
    /// Set the height of Badge, because the Badge width is dynamically and  variable.By changing the Badge height in proportion to facilitate the layout.
    ///
    /// (Note: this method needs to add Badge to the controls and then use it !!!)
    ///
    /// - Parameter points: 高度大小
    public func setBadge(height: CGFloat) {
        _bottomView.tx.setBadge(height: height)
    }

    /// 显示Badge
    public func showBadge() {
        _bottomView.tx.showBadge()
    }

    /// 隐藏Badge
    public func hiddenBadge() {
        _bottomView.tx.hiddenBadge()
    }

    // MARK: - 数字增加/减少, 注意:以下方法只适用于Badge内容为纯数字的情况

    // MARK: - Digital increase /decrease, note: the following method atxlies only to cases where the Badge content is purely numeric

    /// badge数字加1
    public func increase() {
        _bottomView.tx.increase()
    }

    /// badge数字加number
    public func increaseBy(number: Int) {
        _bottomView.tx.increaseBy(number: number)
    }

    /// badge数字加1
    public func decrease() {
        _bottomView.tx.decrease()
    }

    /// badge数字减number
    public func decreaseBy(number: Int) {
        _bottomView.tx.decreaseBy(number: number)
    }

    /// 通过Xcode视图调试工具找到UIBarButtonItem的Badge所在父视图为:UIImageView
    private var _bottomView: UIView {
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
