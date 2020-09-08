//
//  JSAndNativeMenuViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/7.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

class JSAndNativeMenuViewController: BaseGroupTableMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "JSAndNative(WKWebView)"
    }

    override func setMenu() {
        let fisrtMenu = [
            BaseGroupTableMenuModel(code: "Fountion", title: "Fountion(使用WKWebView自带的通信功能)"),
            BaseGroupTableMenuModel(code: "dsBrige", title: "DSBrige"),
            BaseGroupTableMenuModel(code: "WebViewJavascriptBridge", title: "WebViewJavascriptBridge")
        ]
        menu.append(fisrtMenu)
    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        case "Fountion":
            let viewController = JSAndNativeFountionViewController()
            viewController.titleInfo = menuModel.title
            navigationController?.pushViewController(viewController, animated: true)
        case "dsBrige":
            break
        case "WebViewJavascriptBridge":
            break
        default:
            HUD.showText("暂无此模块")
        }
    }

}
