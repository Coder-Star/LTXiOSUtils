//
//  HUD.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/12/14.
//

import Foundation
import MBProgressHUD

open class HUD:MBProgressHUD {
    /// 是否允许点击隐藏
    private var isClickHidden: Bool = false

    /// 显示等待消息
    open class func showWait(_ title: String = "",click:Bool = false) {
        let hud = getHUD(title: title)
        hud.isClickHidden = click
    }

    open class func show(_ title:String,_ delay:Double = 1.0) {
        let hud = getHUD(title: title)
        hud.mode = .text
        hud.hide(animated: true, afterDelay: delay)
    }

    open class func showInfo(_ title:String,_ delay:Double = 1.0) {
        let hud = customHUD(title,image:UIImage(named: ""))
        hud.minSize = CGSize(width:160, height: 80)
        hud.label.font = UIFont.systemFont(ofSize: 18)
        hud.hide(animated: true, afterDelay: delay)
    }

    open class func showSuccess(_ title:String,_ delay:Double = 1.0) {
        let hud = customHUD(title,image:UIImage(named: ""))
        hud.minSize = CGSize(width:160, height: 80)
        hud.label.font = UIFont.systemFont(ofSize: 18)
        hud.hide(animated: true, afterDelay: delay)
    }

    open class func showError(_ title:String,_ delay:Double = 1.0) {
        let hud = customHUD(title,image:UIImage(named: ""))
        hud.minSize = CGSize(width:160, height: 80)
        hud.label.font = UIFont.systemFont(ofSize: 18)
        hud.hide(animated: true, afterDelay: delay)
    }

    open class func customHUD(_ title:String,image:UIImage?) -> HUD {
        let hud = getHUD(title: title)
        hud.mode = .customView
        hud.customView = UIImageView(image: image)
        return hud
    }

    open class func getHUD(title:String = "") -> HUD {
        let view = viewToShow()
        let hud = HUD.showAdded(to: view, animated: true)
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
        return hud
    }

    /// 隐藏消息
    open class func hide() {
        HUD.hide(for:viewToShow(), animated:true)
    }

    /// 获取用于显示提示框的view
    class func viewToShow() -> UIView {
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

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isClickHidden {
            HUD.hide()
        }
    }

}
