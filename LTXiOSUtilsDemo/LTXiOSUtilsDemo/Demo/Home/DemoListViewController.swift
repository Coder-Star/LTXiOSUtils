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
        let addBarButton = UIBarButtonItem(image: R.image.add(), style: .plain, target: self, action: #selector(self.add))
        self.navigationItem.rightBarButtonItem = addBarButton
        // 在viewDidLoad中没法直接获取到UIBarButtonItem的实例，延长一段时间进行获取,不过一般角标都是根据后台返回的，会有一定的时间缓冲
        DispatchQueue.main.delay(0.001) {
            addBarButton.core.addDot(color: .red)
        }
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
