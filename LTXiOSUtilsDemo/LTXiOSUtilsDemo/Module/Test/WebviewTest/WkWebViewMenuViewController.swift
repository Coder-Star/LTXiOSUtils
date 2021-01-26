//
//  JSAndNativeMenuViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/7.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

class WkWebViewMenuViewController: BaseGroupTableMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WKWebView"
    }

    override func setMenu() {
        let fisrtMenu = [
            BaseGroupTableMenuModel(code: "Fountion", title: "Fountion(使用WKWebView自带的通信功能)"),
            BaseGroupTableMenuModel(code: "dsBrige", title: "DSBrige"),
            BaseGroupTableMenuModel(code: "WebViewJavascriptBridge", title: "WebViewJavascriptBridge")
        ]
        menu.append(fisrtMenu)

        let secondMenu = [
            BaseGroupTableMenuModel(code: "WKURLSchemeHandler", title: "WKURLSchemeHandler"),
            BaseGroupTableMenuModel(code: "CustomURLProtocol", title: "CustomURLProtocol")
        ]
        menu.append(secondMenu)
    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        case "Fountion":
            let viewController = JSAndNativeFountionViewController()
            viewController.title = menuModel.title
            navigationController?.pushViewController(viewController, animated: true)
        case "dsBrige":
            let viewController = JSAndNativeDSBrigeViewController()
            viewController.title = menuModel.title
            navigationController?.pushViewController(viewController, animated: true)
        case "WebViewJavascriptBridge":
            let viewController = JSAndNativeJSBrigeViewController()
            viewController.title = menuModel.title
            navigationController?.pushViewController(viewController, animated: true)
        case "WKURLSchemeHandler":
            let viewController = InterceptWkWebViewURLViewController()
            viewController.type = .wkURLSchemeHandler
            viewController.title = menuModel.title
            navigationController?.pushViewController(viewController, animated: true)
        case "CustomURLProtocol":
            let viewController = InterceptWkWebViewURLViewController()
            viewController.type = .customURLProtocol
            viewController.title = menuModel.title
            navigationController?.pushViewController(viewController, animated: true)
        default:
            HUD.showText("暂无此模块")
        }
    }
}

extension WkWebViewMenuViewController {
    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        if section == 0 {
            label.text = "  JS&Native通信"
        } else if section == 1 {
            label.text = "  拦截JS请求"
        }
        return label
    }

    open override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
