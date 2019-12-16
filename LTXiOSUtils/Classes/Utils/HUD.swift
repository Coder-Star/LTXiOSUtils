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

open class HUD: MBProgressHUD {

    /// 是否允许点击隐藏
    private var isClickHidden: Bool = false

    /// 文本内容
    /// - Parameters:
    ///   - title: 标题
    ///   - delayTime: 延迟时间，默认为1.5s
    @discardableResult
    public class func showText(_ title: String, _ delayTime: Double = 1.5) -> HUD {
        let hud = getBaseHUD()
        hud.detailsLabel.text = title
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 14)
        hud.mode = .text
        hud.hide(animated: true, afterDelay: delayTime)
        return hud
    }

    /// 菊花框
    /// - Parameters:
    ///   - title: 标题
    ///   - isClickHidden: 是否可点击消失，默认不可点击消失
    @discardableResult
    open class func showWait(title: String = "", isClickHidden: Bool = false) -> HUD {
        let hud = getBaseHUD()
        hud.detailsLabel.text = title
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 14)
        hud.isClickHidden = isClickHidden
        return hud
    }

    /// 显示进度框
    /// - Parameter title: 标题
    @discardableResult
    open class func showProgress(title: String) -> HUD {
        let hud = getBaseHUD()
        hud.detailsLabel.text = title
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 14)
        hud.mode = .determinateHorizontalBar
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
            DispatchQueue.main.delay(0.5) {
                self.hide(animated: true)
            }
        }
    }

    /// 隐藏消息
    open class func hide() {
        HUD.hide(for: viewToShow(), animated: true)
    }

    /// 获取基础HUD
    open class func getBaseHUD() -> HUD {
        let view = viewToShow()
        let hud = HUD.showAdded(to: view, animated: true)
        return hud
    }

    /// 设置显示样式，暂不支持
    /// - Parameters:
    ///   - hud: HUD
    ///   - style: 样式
    private class func setStyle(hud: HUD, style: HUDStyle) {
        if style == .black {
            hud.bezelView.style = .solidColor
            hud.bezelView.backgroundColor = .black
            UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [HUD.self]).color = .white
            hud.label.textColor = .white
            hud.detailsLabel.textColor = .white
        }
    }

    /// 获取用于显示提示框的view
    private class func viewToShow() -> UIView {
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
        return window!
    }

    /// 点击事件，控制HUD是否可以点击消失
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isClickHidden {
            HUD.hide()
        }
    }

}
