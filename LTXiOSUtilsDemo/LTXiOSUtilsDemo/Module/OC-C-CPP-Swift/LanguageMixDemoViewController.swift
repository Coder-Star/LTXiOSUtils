//
//  LanguageMixDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2021/3/3.
//  Copyright © 2021 李天星. All rights reserved.
//

import Foundation

class LanguageMixDemoViewController: BaseGroupTableMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "OC-C-CPP-Swift"
    }

    override func setMenu() {
        let fisrtMenu = [
            BaseGroupTableMenuModel(code: "Swift-OC", title: "Swift调用OC"),
            BaseGroupTableMenuModel(code: "Swift-C", title: "Swift调用C"),
            BaseGroupTableMenuModel(code: "Swift-C++", title: "Swift调用C++")
        ]
        menu.append(fisrtMenu)

        let secondMenu = [
            BaseGroupTableMenuModel(code: "OC-Swift", title: "OC调用Swift")
        ]
        menu.append(secondMenu)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.accessoryType = .none
        return cell
    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        case "Swift-OC":
            OC_Swift().testOC()
        case "Swift-C":
            testCVoid()
            let result = testCInt(1)
            Log.d(result)
        case "Swift-C++":
            TestCPPWrapper().testCPP()
        case "OC-Swift":
            /// 实际上OC文件中定义的方法名为testSwift，不知道为什么直接变成了test
            OC_Swift().test()
        default:
            HUD.showText("暂无此模块")
        }
    }
}
