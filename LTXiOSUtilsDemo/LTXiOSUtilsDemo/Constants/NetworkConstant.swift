//
//  NetworkConstant.swift
//  BaseIOSProject
//  url定义
//  Created by 李天星 on 2019/9/3.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation

/// 网络请求常量
public class NetworkConstant: NSObject {

    static let isFormal = false //是否正式,正式版为true,测试版为false

    private static var oaUrlInfo = ""

    class func initUrlInfo() {
        NetworkConfig.baseURL = "http://172.20.3.53:8924/fms/"

        if NetworkConstant.isFormal {
            NetworkConstant.oaUrlInfo = "http://oa.topscomm.net:8932/"
        } else {
            NetworkConstant.oaUrlInfo = "http://172.20.3.53:8919/toa/"
        }

    }

    // static let 是自动懒加载的，所以当initUrlInfo被调用之前没有访问OaUrl，逻辑没有问题，如果访问了OaUrl，就有问题了
    static let OaUrl: String = NetworkConstant.oaUrlInfo

}

extension NetworkConstant {
    struct ER {
        static let loginUrl = "toa/toaMobileLogin_login.json"
        static let erMobileCommonUploadFile = "er/erMobileCommon_uploadFile.json"
    }
}

// MARK: - APP自身相关url
extension NetworkConstant {
    static let appUrl = "http://121.36.20.56:8080/LTXiOSUtils/"
    static let launchAdData = "LaunchAd/data.json"
    static let bannerUrl = "PagerView/data.json"
}
