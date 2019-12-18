//
//  NetWorkDemoMenuViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2019/12/18.
//  Copyright © 2019 李天星. All rights reserved.
//

import Foundation

class NetworkDemoMenuViewController: BaseGroupTableMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "网络请求"
    }

    override func setMenu() {
        let fisrtMenu = [
            [ConstantsEnum.title:"请求",ConstantsEnum.image:"",ConstantsEnum.code:"request"],
            [ConstantsEnum.title:"上传",ConstantsEnum.image:"",ConstantsEnum.code:"upload"],
            [ConstantsEnum.title:"下载",ConstantsEnum.image:"",ConstantsEnum.code:"download"]
        ]
        menu.append(fisrtMenu)
    }

    override func click(code: String, title: String) {
        switch code {
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

}

extension NetworkDemoMenuViewController {
    func request() {
        let parameters: Parameters = ["loginname":"6918","password":"1234567","uuid":"","ismobile":"1"]
        let baseUrl = "http://172.20.3.53:8919/toa1"
        let path = "/toa/toaMobileLogin_login1.json"
        let requestParam = RequestParam(baseUrl:baseUrl, path: path,parameters:parameters)
        NetworkManager.sendRequest(requestParam:requestParam) { data in
            QL1(data)
        }
    }
}

extension NetworkDemoMenuViewController {
    func upload() {

    }
}

extension NetworkDemoMenuViewController {
    func download() {

    }
}
