//
//  NetworkConstant.swift
//  BaseIOSProject
//  url定义
//  Created by 李天星 on 2019/9/3.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation

/// 网络请求常量
public struct NetworkConstant {
    static let isFormal = false //是否正式,正式版为true,测试版为false
    static let isBanLog = false //是否禁止打印日志，true不打印，false打印

    private static var oaUrlInfo = ""
    private static var erUrlInfo = ""

    static func initUrlInfo() {
        NetworkConfig.baseURL = "http://172.20.3.53:8924/fms/"

        if NetworkConstant.isFormal {
            NetworkConstant.oaUrlInfo = "http://172.20.3.53:8919/toa/"
            NetworkConstant.erUrlInfo = "http://172.20.3.53:8919/toa/"
        } else {
            NetworkConstant.oaUrlInfo = "http://172.20.3.53:8919/toa/"
            NetworkConstant.erUrlInfo = "http://172.20.3.53:8919/toa/"
        }
    }

    static let OaUrl: String = NetworkConstant.oaUrlInfo
    static let ErUrl: String = NetworkConstant.erUrlInfo

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
