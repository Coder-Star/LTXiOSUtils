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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.menu()
    }

    override func setMenu() {
        let fisrtMenu = [
            [ConstantsEnum.title:"HUD加载框",ConstantsEnum.image:"",ConstantsEnum.code:"HUD"]
        ]
        menu.append(fisrtMenu)
    }

    override func click(code: String, title: String) {
        switch code {
        case "HUD":
            navigationController?.pushViewController(HUDDemoViewController(), animated: true)
        default:
            HUD.showText("暂无此模块")
        }
    }
}
