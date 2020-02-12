//
//  DemoListViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2019/8/2.
//  Copyright © 2019年 李天星. All rights reserved.
//

import UIKit
import LTXiOSUtils

class DemoListViewController: BaseGroupTableMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let addBarButton = UIBarButtonItem(image: R.image.add(), style: .plain, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = addBarButton
    }

    @objc private func add() {
        QL1("添加")
    }

    override func setMenu() {
        let componetMenu = [
            BaseGroupTableMenuModel(code: "HUD", title: "HUD加载框"),
            BaseGroupTableMenuModel(code: "Pick", title: "选择器"),
            BaseGroupTableMenuModel(code: "Component", title: "控件集锦"),
            BaseGroupTableMenuModel(code: "Menu", title: "菜单"),
            BaseGroupTableMenuModel(code: "TreeView", title: "无限级树形View")
        ]
        menu.append(componetMenu)

        let networkMenu = [
            BaseGroupTableMenuModel(code: "Network", title: "网络请求相关")
        ]
        menu.append(networkMenu)

        let extensionMenu = [
            BaseGroupTableMenuModel(code: "Extension", title: "扩展")
        ]
        menu.append(extensionMenu)

    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        case "HUD":
            navigationController?.pushViewController(HUDDemoViewController(), animated: true)
        case "Network":
            navigationController?.pushViewController(NetworkDemoViewController(), animated: true)
        case "Pick":
            navigationController?.pushViewController(PickViewDemoViewController(), animated: true)
        case "Component":
            navigationController?.pushViewController(ComponentCollectionsViewController(), animated: true)
        case "Extension":
            navigationController?.pushViewController(ExtensionExampleMenuViewController(), animated: true)
        case "Menu":
            navigationController?.pushViewController(GridMenuViewExampleViewController(), animated: true)
        case "TreeView":
            navigationController?.pushViewController(TreeViewDemoViewController(), animated: true)
        default:
            HUD.showText("暂无此模块")
        }
    }
}
