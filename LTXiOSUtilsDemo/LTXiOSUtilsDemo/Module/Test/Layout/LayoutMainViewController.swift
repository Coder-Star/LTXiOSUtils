//
//  LayoutMainViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/15.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class LayoutMainViewController: BaseGroupTableMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Layout"
    }

    override func setMenu() {
        let fisrtMenu = [
            BaseGroupTableMenuModel(code: "Xib", title: "Xib"),
            BaseGroupTableMenuModel(code: "StoryBoard", title: "StoryBoard"),
            BaseGroupTableMenuModel(code: "SwiftUI", title: "SwiftUI")
        ]
        menu.append(fisrtMenu)

        let secondMenu = [
            BaseGroupTableMenuModel(code: "UIView", title: "UIView底层相关")
        ]
        menu.append(secondMenu)
    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        case "Xib":
            break
        case "StoryBoard":
            let storyboard = UIStoryboard(name: "StoryboardMain", bundle: nil)
            // 指定VC
            //            let viewController = storyboard.instantiateViewController(withIdentifier: "StoryboardSecondVC")
            guard let viewController = storyboard.instantiateInitialViewController() else {
                return
            }
            navigationController?.pushViewController(viewController, animated: true)
        case "SwiftUI":
            let viewController = UIHostingController(rootView: ContentView())
            navigationController?.pushViewController(viewController, animated: true)
        case "UIView":
            break
        default:
            HUD.showText("暂无此模块")
        }
    }
}
