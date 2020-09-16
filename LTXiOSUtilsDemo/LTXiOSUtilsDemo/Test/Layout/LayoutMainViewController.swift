
//
//  LayoutMainViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/15.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

class LayoutMainViewController: BaseGroupTableMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Layout"
    }

    override func setMenu() {
        let fisrtMenu = [
            BaseGroupTableMenuModel(code: "Xib", title: "Xib"),
            BaseGroupTableMenuModel(code: "StoryBoard", title: "StoryBoard")
        ]
        menu.append(fisrtMenu)
    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        case "Xib":
            fallthrough
        case "StoryBoard":
            fallthrough
        default:
            HUD.showText("暂无此模块")
        }
    }
}
