//
//  ExtensionExampleMenuViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/1/7.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

class ExtensionExampleMenuViewController: BaseGroupTableMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "扩展示例Demo"
    }

    override func setMenu() {
        let fisrtMenu = [
            BaseGroupTableMenuModel(code: "View", title: "View")
        ]
        menu.append(fisrtMenu)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.accessoryType = .none
        return cell
    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        case "View":
            navigationController?.pushViewController(UIViewExtensionExampleViewController(), animated: true)
        default:
            HUD.showText("暂无此模块")
        }
    }

}
