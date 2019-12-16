//
//  ViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2019/8/2.
//  Copyright © 2019年 李天星. All rights reserved.
//

import UIKit
import LTXiOSUtils

class ViewController: BaseGroupTableMenuViewController {
    var hud:HUD!
    var timer:Timer!
    var i:Float = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.menu()
    }
    //ConstantsEnum
    override func setMenu() {
        let fisrtMenu = [
            [ConstantsEnum.title:"第一个功能",ConstantsEnum.image:"123",ConstantsEnum.code:"123"]
        ]
        menu.append(fisrtMenu)
    }

    override func click(code: String) {
        hud = HUD.showProgress(title: "123")
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(time), userInfo: nil, repeats: true)
        timer.fire()

    }

    @objc func time() {
        i += 0.1
        hud.updateProgress(progress: i, title: "这是\(i)", successTitle: "完成")
    }
}
