//
//  NetworkConfig.swift
//  LTXiOSUtils
//  网络相关配置
//  Created by 李天星 on 2019/9/3.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation
import Moya

/// 网络请求配置类
public struct NetworkConfig {
    /// 默认超时时间,单位为秒
    public static var requestTimeOut: Double = 30.0

    /// token认证key值
    public static var Authorization = "Authorization"

    /// 令牌字符串,如果将该值赋值，则所有请求都会加上令牌
    public static var token = ""

    /// 服务器默认基础地址
    public static var baseURL = ""

    /// 请求默认method
    public static var method: Moya.Method = .post

}
