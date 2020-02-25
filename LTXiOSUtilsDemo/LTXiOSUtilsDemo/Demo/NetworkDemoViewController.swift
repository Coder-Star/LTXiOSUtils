//
//  NetWorkDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2019/12/18.
//  Copyright © 2019 李天星. All rights reserved.
//

import Foundation

class NetworkDemoViewController: BaseGroupTableMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "网络请求"
    }

    override func setMenu() {
        let fisrtMenu = [
            BaseGroupTableMenuModel(code: "request", title: "请求"),
            BaseGroupTableMenuModel(code: "upload", title: "上传"),
            BaseGroupTableMenuModel(code: "download", title: "下载")
        ]
        menu.append(fisrtMenu)
    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        case "request":
            request()
        case "upload":
            upload()
        case "download":
            download()
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

extension NetworkDemoViewController {
    func request() {
        let parameters: Parameters = ["loginname":"6918","password":"1234567","uuid":"","ismobile":"1"]
        let baseUrl = "http://172.20.3.53:8919/toa"
        let path = "/toa/toaMobileLogin_login.json"
        let requestParam = RequestParam(baseUrl:baseUrl, path: path,parameters:parameters)
        NetworkManager.sendRequest(requestParam:requestParam) { data in
            Log.d(data)
        }
    }
}

extension NetworkDemoViewController {
    func upload() {

    }
}

extension NetworkDemoViewController {
    func download() {

    }
}
