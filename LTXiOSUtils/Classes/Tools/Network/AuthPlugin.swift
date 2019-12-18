//
//  AuthPlugin.swift
//  LTXiOSUtils
//  令牌插件
//  Created by 李天星 on 2019/9/4.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation
import Moya
import Result

public struct AuthPlugin: PluginType {
    /// 令牌字符串
    public var token: String = "defalutToken"

    /// 准备网络请求
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target as? CustomizeTargetType, target.needAuth else {
            return request
        }
        var request = request
        request.addValue(token, forHTTPHeaderField: NetworkConfig.Authorization) //将token添加到请求头中
        return request
    }

    /// 即将发送网络请求
    public func willSend(_ request: RequestType, target: TargetType) {

    }

    /// 收到数据
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {

    }

    /// 请求进度
    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        return result
    }

}
