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

    static func initUrlInfo() {
        NetworkConfig.baseURL = "https://www.fastmock.site/mock/5abd18409d0a2270b34088a07457e68f/LTXMock"
    }
}

// MARK: - APP自身相关url
extension NetworkConstant {
    static let launchAdData = "LaunchAd/data.json"
    static let bannerUrl = "pagerViewConfigInfo"
}
