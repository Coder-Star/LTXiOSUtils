//
//  MediatorAndRouterDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/4/21.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import UIKit
import MGJRouter

class MediatorAndRouterDemoViewController: BaseGroupTableMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MediatorAndRouter"
    }

    override func setMenu() {
        let fisrtMenu = [
            BaseGroupTableMenuModel(code: "routerA", title: "基本使用"),
            BaseGroupTableMenuModel(code: "routerB", title: "中文匹配"),
            BaseGroupTableMenuModel(code: "routerC", title: "传递自定义参数(首个参数带形参名)"),
            BaseGroupTableMenuModel(code: "routerD", title: "传递自定义参数(首个参数不带形参名)"),
            BaseGroupTableMenuModel(code: "routerE", title: "传递字典信息"),
            BaseGroupTableMenuModel(code: "routerF", title: "全局的URL Pattern(匹配不到的统一进入这个)"),
            BaseGroupTableMenuModel(code: "routerG", title: "模板生成URL"),
            BaseGroupTableMenuModel(code: "routerH", title: "opneUrl结束执行Completion Block"),
            BaseGroupTableMenuModel(code: "routerI", title: "同步获取URL对应的Object"),
            BaseGroupTableMenuModel(code: "routerJ", title: "组件使用Protocol")
        ]
        menu.append(fisrtMenu)
        let sencondMenu = [
            BaseGroupTableMenuModel(code: "mediatorA", title: "mediatorA"),
            BaseGroupTableMenuModel(code: "mediatorB", title: "mediatorB")
        ]
        menu.append(sencondMenu)
    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        // 基本使用
        case "routerA":
            let routerUrl = MGJRouterDemoViewController.routerPrefix + "MGJRouterDemo"
            if MGJRouter.canOpenURL(routerUrl, matchExactly: true) {
                MGJRouter.openURL(routerUrl)
            }
        // 路径中含有中文
        case "routerB":
            let routerUrl = MGJRouterDemoViewController.routerPrefix + "category/购物"
            MGJRouter.openURL(routerUrl)

            // 如果路径中含有中文，想要使用canOpenURL这个方法，需要对url进行编码
//            let routerUrl = (MGJRouterDemoViewController.routerPrefix + "category/购物").urlEncode
//            if MGJRouter.canOpenURL(routerUrl, matchExactly: true) {
//                MGJRouter.openURL(routerUrl)
//            }
        // 传递自定义参数(首个参数带形参名)
        case "routerC":
            let routerUrl = MGJRouterDemoViewController.routerPrefix + "MGJRouterDemo?type=sport"
            if MGJRouter.canOpenURL(routerUrl, matchExactly: true) {
                MGJRouter.openURL(routerUrl)
            }
        // 传递自定义参数(首个参数不带形参名)
        case "routerD":
            let routerUrl = MGJRouterDemoViewController.routerPrefix + "MGJRouterDemo/Custom_Variables?color=red"
            if MGJRouter.canOpenURL(routerUrl, matchExactly: true) {
                MGJRouter.openURL(routerUrl)
            }
        // 传入字典
        case "routerE":
            let routerUrl = MGJRouterDemoViewController.routerPrefix + "MGJRouterDemo"
            let withUserInfo = ["key": "name", "value": "李天星"]
            if MGJRouter.canOpenURL(routerUrl, matchExactly: true) {
                MGJRouter.openURL(routerUrl, withUserInfo: withUserInfo, completion: nil)
            }
        // 全局的URL Pattern
        case "routerF":
            let routerUrl = MGJRouterDemoViewController.routerPrefix + "AAAAA/BBBB"
            if MGJRouter.canOpenURL(routerUrl, matchExactly: true) {
                MGJRouter.openURL(routerUrl)
            }
        // 模板生成URL,原理是利用数组的value去替换对应位置的 :key
        case "routerG":
            let routerUrl = MGJRouterDemoViewController.routerPrefix + "MGJRouterDemo/:type?loginName=:loginName"
            let routerGenerateURL = MGJRouter.generateURL(withPattern: routerUrl, parameters: ["wash", "CoderStar"])
            if MGJRouter.canOpenURL(routerGenerateURL, matchExactly: true) {
                MGJRouter.openURL(routerGenerateURL)
            }
        // opneUrl结束执行Completion Block
        case "routerH":
            let routerUrl = MGJRouterDemoViewController.routerPrefix + "MGJRouterDemoBlock"
            if MGJRouter.canOpenURL(routerUrl, matchExactly: true) {
                MGJRouter.openURL(routerUrl, withUserInfo: ["content": "闭包回传"]) { info in
                    Log.d(info)
                    if let viewController = info as? UIViewController {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
        // 同步获取URL对应的Object
        case "routerI":
            let routerUrl = MGJRouterDemoViewController.routerPrefix + "MGJRouterDemoObject"
            let content = ["content": "获取URL对应的Object"]
            if MGJRouter.canOpenURL(routerUrl, matchExactly: true) {
                MGJRouter.openURL(routerUrl, withUserInfo: content) { info in
                    Log.d(info)
                    if let viewController = info as? UIViewController {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
            let info = MGJRouter.object(forURL: routerUrl, withUserInfo: content)
            Log.d(info)
        // 组件使用Protocol
        case "routerJ":
            Log.d(BaseGroupTableMenuViewController().description)
        default:
            HUD.showText("暂无此模块")
        }
    }
}

extension MediatorAndRouterDemoViewController {
    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        if section == 0 {
            label.text = "  MGJRouter"
        } else if section == 1 {
            label.text = "  CTMediator"
        }
        return label
    }

    open override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
