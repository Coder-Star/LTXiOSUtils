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

    static func initUrlInfo() {
        #if TEST
        NetworkDefaultConfig.baseURL = "https://www.fastmock.site/mock/5abd18409d0a2270b34088a07457e68f/LTXMock"
        #else
        NetworkDefaultConfig.baseURL = "https://www.fastmock.site/mock/5abd18409d0a2270b34088a07457e68f/LTXMock"
        #endif
    }
}

// MARK: - APP自身相关url
extension NetworkConstant {

    /// 轮播图配置地址
    static let bannerUrl = "pagerViewConfigInfo"
}
