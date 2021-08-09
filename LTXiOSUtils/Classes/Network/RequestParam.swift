//
//  RequestParam.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2019/9/6.
//  Copyright © 2019年 CoderStar. All rights reserved.
//

import Foundation
import Moya

/// 网络请求参数类
public struct RequestParam {
    /// 基础url
    public var baseUrl: String = NetworkDefaultConfig.baseURL
    /// 请求路径
    public var path: String
    /// 传递参数
    public var parameters = [String: Any]()
    /// token
    public var token: String = NetworkDefaultConfig.token
    /// 超时时间
    public var timeOut: Double = NetworkDefaultConfig.requestTimeOut
    /// 请求方法
    public var method: Moya.Method = NetworkDefaultConfig.method
    /// header设置
    public var header: [String: String]?
    /// 上传文件数组
    public var fileList: [FileInfo]?
    /// 是否忽略错误
    /// 如果忽略错误，则retryCount重试机制不再生效
    public var ignoreError: Bool = false
    /// 重试次数，大于0时进行重试
    public var retryCount: Int = 0
    /// 请求编码
    /// 其中，如果使用参数传递方式，encoding为URLEncoding.default；如果使用json方式，encoding为JSONEncoding.default
    public var parameterEncoding: ParameterEncoding = URLEncoding.default

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
        if self.token.tx.isNotEmpty {
            Log.d("token: \(self.token)")
        }
        if self.header.isNotNil {
            Log.d("header: \(String(describing: self.header?.description))")
        }
        if self.fileList.isNotNil {
            Log.d("file: \(String(describing: self.fileList?.compactMap { $0.name }.description))")
            Log.d("file: \(String(describing: self.fileList?.compactMap { $0.data }.description))")
        }
    }
}

/// 文件信息
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
        self.size = String(format: "%.2f", Double(data.count) / 1_024.0) + "KB"
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
        self.size = String(format: "%.2f", Double(data.count) / 1_024.0) + "KB"
        if let tempType = name.split(separator: ".").last {
            self.type = ".\(tempType)"
        } else {
            self.type = ""
        }
        self.data = data
    }
}
