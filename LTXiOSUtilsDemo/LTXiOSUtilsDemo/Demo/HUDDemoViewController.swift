//
//  HUDDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2019/12/16.
//  Copyright © 2019 李天星. All rights reserved.
//

import Foundation

class HUDDemoViewController: BaseGroupTableMenuViewController {

    var hud:HUD?
    var timer:Timer?
    var progresss:Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HUD"
    }

    override func setMenu() {
        let fisrtMenu = [
            BaseGroupTableMenuModel(code: "text", title: "文本"),
            BaseGroupTableMenuModel(code: "wait", title: "菊花框"),
            BaseGroupTableMenuModel(code: "progress", title: "横向进度条")
        ]
        menu.append(fisrtMenu)
    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        case "text":
            HUD.showText(menuModel.title)
        case "wait":
            HUD.showWait(title: "一秒后自动消失")
            DispatchQueue.main.delay(1) {
                HUD.hide()
            }
        case "progress":
            hud = HUD.showProgress(title: "开始加载")
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerExecute), userInfo: nil, repeats: true)
            timer?.fire()
        default:
            HUD.showText("暂无此模块")
        }
    }

    @objc func timerExecute() {
        progresss += 0.1
        hud?.updateProgress(progress: progresss, title: "当前进度:\(progresss)", successTitle: "完成")
        if progresss > 1 {
            timer?.invalidate()
        }
    }

}
