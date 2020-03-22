//
//  HUD.swift
//  LTXiOSUtils
//  HUD
//  Created by 李天星 on 2019/12/14.
//

// MBProgressHUD模式种类
// determinateHorizontalBar 水平进度条
// annularDeterminate 环形进度条
// determinate 饼状进度条
// customView 自定义view
// text 文字
// indeterminate 菊花框，默认

import Foundation
import MBProgressHUD
import UIKit

/// HUD样式
public enum HUDStyle {
    /// 默认
    case `default`
    /// 黑色
    case black
}

/// HUD显示位置
public enum HUDPosition {
    /// 顶部
    case top
    /// 中心
    case center
    /// 底部
    case bottom
}

open class HUD: MBProgressHUD {

    /// 是否允许点击隐藏
    private var isClickHidden: Bool = false
    /// 显示text 顶部垂直margin
    public static var topMargin: CGFloat = 92
    /// 显示text 顶部底部margin
    public static var bottomMargin: CGFloat = 92

    /// 文本内容
    /// - Parameters:
    ///   - title: 标题
    ///   - delayTime: 延迟时间，默认为1.5s
    ///   - style: 显示样式
    @discardableResult
    public class func showText(_ title: String, _ delayTime: Double = 1.5, position: HUDPosition = .center, style: HUDStyle = .black) -> HUD? {
        let hud = getBaseHUD(style: style)
        hud?.detailsLabel.text = title
        hud?.detailsLabel.font = UIFont.systemFont(ofSize: 14)
        hud?.mode = .text
        switch position {
        case .top:
            hud?.offset.y = (UIScreen.main.bounds.size.height / 2 - HUD.topMargin) * -1
        case .center:
            hud?.offset.y = 0
        case .bottom:
            hud?.offset.y = UIScreen.main.bounds.size.height / 2 - HUD.bottomMargin
        }

        hud?.margin = 10
        hud?.setStyle(style: style)
        hud?.hide(animated: true, afterDelay: delayTime)
        return hud
    }

    /// 菊花框
    /// - Parameters:
    ///   - title: 标题
    ///   - isClickHidden: 是否可点击消失，默认不可点击消失
    ///   - style: 显示样式
    @discardableResult
    open class func showWait(title: String = "", style: HUDStyle = .black, isClickHidden: Bool = false) -> HUD? {
        let hud = getBaseHUD(style: style)
        hud?.detailsLabel.text = title
        hud?.detailsLabel.font = UIFont.systemFont(ofSize: 14)
        hud?.isClickHidden = isClickHidden
        hud?.setStyle(style: style)
        return hud
    }

    /// 显示进度框,与updateProgress搭配使用
    /// - Parameter title: 标题
    /// - Parameter style: 显示样式
    @discardableResult
    open class func showProgress(title: String, style: HUDStyle = .default) -> HUD? {
        let hud = getBaseHUD(style: style)
        hud?.setStyle(style: style)
        hud?.detailsLabel.text = title
        hud?.detailsLabel.font = UIFont.systemFont(ofSize: 14)
        hud?.mode = .determinateHorizontalBar
        return hud
    }

    /// 更新进度框进度
    /// - Parameters:
    ///   - progress: 进度，需小于1，当大于等于1时会认为其执行完成，隐藏进度框
    ///   - title: 进度框标题
    ///   - successTitle: 指定完成标题
    open func updateProgress(progress: Float, title: String, successTitle: String) {
        self.detailsLabel.text = title
        self.progress = progress
        if progress >= 1 {
            self.detailsLabel.text = successTitle
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.hide(animated: true)
            }
        }
    }

    /// 隐藏消息
    open class func hide() {
        if let view = viewToShow() {
            HUD.hide(for: view, animated: true)
        }
    }

    /// 获取基础HUD
    open class func getBaseHUD(style: HUDStyle) -> HUD? {
        if let view = viewToShow() {
            switch style {
            case .default:
                UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self]).color = .black
            case .black:
                UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self]).color = .white
            }
            let hud = HUD.showAdded(to: view, animated: true)
            hud.removeFromSuperViewOnHide = true
            return hud
        }
        return nil
    }

    /// 设置显示样式
    /// - Parameters:
    ///   - style: 样式
    private func setStyle(style: HUDStyle) {
        if style == .black {
            self.bezelView.style = .solidColor
            self.bezelView.backgroundColor = .black
            self.label.textColor = .white
            self.contentColor = .white
            self.detailsLabel.textColor = .white
        }
    }

    /// 获取用于显示提示框的view
    private class func viewToShow() -> UIView? {
        var window = UIApplication.shared.keyWindow
        DispatchQueue.main.async {
            if window?.windowLevel != UIWindow.Level.normal {
                let windowArray = UIApplication.shared.windows
                for tempWin in windowArray where tempWin.windowLevel == UIWindow.Level.normal {
                    window = tempWin
                    break
                }
            }
        }
        return window
    }

    /// 点击事件，控制HUD是否可以点击消失
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isClickHidden {
            HUD.hide()
        }
    }

}
