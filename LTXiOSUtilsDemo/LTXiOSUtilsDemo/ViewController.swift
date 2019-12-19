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
            BaseGroupTableMenuModel(code: "HUD", title: "HUD加载框"),
            BaseGroupTableMenuModel(code: "Network", title: "网络请求相关")
        ]
        menu.append(fisrtMenu)
    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        case "HUD":
            navigationController?.pushViewController(HUDDemoViewController(), animated: true)
        case "Network":
            navigationController?.pushViewController(NetworkDemoMenuViewController(), animated: true)
        default:
            HUD.showText("暂无此模块")
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.accessoryType = .none
        return cell
    }
}
