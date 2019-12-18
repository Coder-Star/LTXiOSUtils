//
//  RequestParam.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/9/6.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation
import Moya

/// 网络请求参数类
public class RequestParam {
    /// 基础url
    public var baseUrl: String = ""
    /// 请求路径
    public var path: String = ""
    /// 传递参数
    public var parameters: [String: Any] = [String: Any]()
    /// 等待框相关配置
    public var hud: HudConfig = HudConfig()
    /// 是否需要token
    public var needAuth: Bool = true
    ///  当needAuth为true，可以设置token值将某个请求定制一个token
    public var token: String = ""
    /// 超时时间
    public var timeOut: Double = NetworkConfig.requestTimeOut
    /// 请求方法
    public var method: Moya.Method = .post
    /// header设置
    public var header: [String: String]?
    /// 上传文件数组
    public var fileList: [FileInfo]?

    /// 构造函数
    public init(baseUrl: String, path: String) {
        self.baseUrl = baseUrl
        self.path = path
    }

    /// 构造函数
    public init(baseUrl: String, path: String, parameters: [String: Any]) {
        self.baseUrl = baseUrl
        self.path = path
        self.parameters = parameters
    }

    /// 打印信息
    public class func printInfo(requestParam: RequestParam) {
        print("baseUrl: \(requestParam.baseUrl)")
        print("path: \(requestParam.path)")
        print("parameters: \(requestParam.parameters)")
        print("hud: \(requestParam.hud)")
        print("needAuth: \(requestParam.needAuth)")
        print("token: \(requestParam.token)")
        print("method: \(requestParam.method)")
        print("header: \(requestParam.header ?? ["": ""])")
        print("file: \(requestParam.fileList ?? [FileInfo()])")
    }
}

///文件信息
public class FileInfo {
    /// 数据
    public var data: Data = Data()
    /// 文件名称
    public var name: String = ""
    /// 文件尺寸
    public var size: String = ""
    /// 文件类型
    public var type: String = ""
}

/// 菊花框相关配置
public class HudConfig {
    /// 构造函数
    public init() {

    }
    /// 是否显示
    public var isShow: Bool = true
    /// 是否可以点击停止
    public var clickCancel: Bool = false
    /// 显示title
    public var title = ""
}
