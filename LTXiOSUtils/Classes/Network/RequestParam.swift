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
public struct RequestParam {
    /// 基础url
    public var baseUrl: String = NetworkConfig.baseURL
    /// 请求路径
    public var path: String
    /// 传递参数
    public var parameters: [String: Any] = [String: Any]()
    /// 等待框相关配置
    public var hud: HudConfig = HudConfig()
    /// token
    public var token: String = NetworkConfig.token
    /// 超时时间
    public var timeOut: Double = NetworkConfig.requestTimeOut
    /// 请求方法
    public var method: Moya.Method = NetworkConfig.method
    /// header设置
    public var header: [String: String]?
    /// 上传文件数组
    public var fileList: [FileInfo]?
    /// 是否忽略错误
    /// 如果忽略错误，则retryCount重试机制不再生效
    public var ignoreError: Bool = false
    /// 重试次数，大于0时进行重试
    public var retryCount: Int = 0

    /// 构造函数
    public init(path: String) {
        self.path = path
    }

    /// 构造函数
    public init(path: String, parameters: [String: Any]) {
        self.path = path
        self.parameters = parameters
    }

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
    public func printInfo() {
        Log.d("url: \(self.baseUrl + self.path)")
        Log.d("parameters: \(self.parameters)")
        Log.d("method: \(self.method)")
        if self.token.isNotEmpty {
            Log.d("token: \(self.token)")
        }
        if self.header.isNotNil {
            Log.d("header: \(String(describing: self.header?.description))")
        }
        if self.fileList.isNotNil {
            Log.d("file: \(String(describing: self.fileList?.compactMap {$0.name}.description))")
            Log.d("file: \(String(describing: self.fileList?.compactMap {$0.data}.description))")
        }
    }
}

///文件信息
public struct FileInfo {
    /// 数据
    public var data: Data
    /// 文件名称
    public var name: String
    /// 文件尺寸
    public var size: String
    /// 文件类型
    public var type: String

    /// 构造函数
    /// - Parameters:
    ///   - name: 文件名称
    ///   - size: 文件尺寸
    ///   - type: 文件类型
    ///   - data: 文件数据
    public init(name: String, size: String, type: String, data: Data) {
        self.name = name
        self.size = size
        self.type = type
        self.data = data
    }

    /// 构造函数
    /// - Parameters:
    ///   - name: 文件名称
    ///   - type: 文件类型
    ///   - data: 文件数据
    public init(name: String, type: String, data: Data) {
        self.name = name
        self.size = String(format: "%.2f", Double(data.count) / 1024.0) + "KB"
        self.type = type
        self.data = data
    }

    /// 构造函数
    /// - Parameters:
    ///   - name: 文件名称
    ///   - type: 文件类型
    ///   - data: 文件数据
    public init(name: String, data: Data) {
        self.name = name
        self.size = String(format: "%.2f", Double(data.count) / 1024.0) + "KB"
        if let tempType = name.split(separator: ".").last {
            self.type = ".\(tempType)"
        } else {
            self.type = ""
        }
        self.data = data
    }
}

/// 菊花框相关配置
public struct HudConfig {
    /// 是否显示，默认显示
    public var isShow: Bool = true
    /// 是否可以点击停止，默认不可以
    public var clickCancel: Bool = false
    /// 显示title，默认为空
    public var title = ""

    /// 构造函数
    public init() {

    }

    /// 构造函数
    /// - Parameter isShow: 是否显示
    public init(isShow: Bool) {
        self.isShow = isShow
    }

    /// 构造函数
    /// - Parameter title: 标题内容
    public init(title: String) {
        self.title = title
    }

    /// 构造函数
    /// - Parameters:
    ///   - isShow: 是否显示
    ///   - clickCancel: 是否可以点击停止
    ///   - title: 标题内容
    public init(isShow: Bool, clickCancel: Bool, title: String) {
        self.isShow = isShow
        self.clickCancel = clickCancel
        self.title = title
    }

}
