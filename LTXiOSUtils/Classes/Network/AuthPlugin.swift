//
//  AuthPlugin.swift
//  LTXiOSUtils
//  令牌插件
//  Created by CoderStar on 2019/9/4.
//  Copyright © 2019年 CoderStar. All rights reserved.
//

import Foundation
import Moya

public struct AuthPlugin: PluginType {
    /// 令牌字符串
    public var token: String = ""

    /// 构造函数
    /// - Parameter token: token
    public init(token: String) {
        self.token = token
    }

    /// 准备网络请求
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard token.tx.isNotEmpty else {
            return request
        }
        var request = request
        request.addValue(token, forHTTPHeaderField: NetworkDefaultConfig.Authorization) // 将token添加到请求头中
        return request
    }

    /// 即将发送网络请求
    public func willSend(_ request: RequestType, target: TargetType) {}

    /// 收到数据
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {}

    /// 请求进度
    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        return result
    }
}
