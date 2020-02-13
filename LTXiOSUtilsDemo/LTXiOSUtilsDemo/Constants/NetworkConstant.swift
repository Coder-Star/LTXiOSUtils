//
//  NetworkConstant.swift
//  BaseIOSProject
//  url定义
//  Created by 李天星 on 2019/9/3.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation

/// 网络请求常量
public class NetworkConstant {
    static let isFormal = false //是否正式,正式版为true,测试版为false
    static let isBanLog = false //是否禁止打印日志，true不打印，false打印

    private static var oaUrlInfo = ""
    private static var erUrlInfo = ""

    class func setBaseUrl() {
        if NetworkConstant.isFormal {
            NetworkConstant.oaUrlInfo = "http://172.20.3.53:8919/toa/"
            NetworkConstant.erUrlInfo = "http://172.20.3.53:8919/toa/"
        } else {
            NetworkConstant.oaUrlInfo = "http://172.20.3.53:8919/toa/"
            NetworkConstant.erUrlInfo = "http://172.20.3.53:8919/toa/"
        }
    }

    static let OaUrl:String = NetworkConstant.oaUrlInfo
    static let ErUrl:String =  NetworkConstant.erUrlInfo

    struct OA {
        static let loginUrl =  "toa/toaMobileLogin_login.json"
    }

    struct ER {
        static let loginUrl =  "toa/toaMobileLogin_login.json"
    }

    static let appUrl = "http://121.36.20.56:8080/LTXiOSUtils/"
    static let launchAdData = "LaunchAd/data.json"
}
