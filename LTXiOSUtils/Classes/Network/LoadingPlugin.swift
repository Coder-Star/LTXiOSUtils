//
//  NetworkRequestAlertPlugin.swift
//  LTXiOSUtils
//  等待框插件
//  Created by 李天星 on 2019/9/4.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation
import Moya

public class LoadingPlugin: PluginType {
    /// 准备网络请求,将TargetType映射为TargetType之后执行，这是请求前对URLRequest进行编辑的最后机会，如为URLRequest添加Header等
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }

    /// 即将发送网络请求，这是检查请求的机会,添加日志等
    public func willSend(_ request: RequestType, target: TargetType) {
        guard let target = target as? CustomizeTargetType, target.hudConfig.isShow else {
            return
        }
        HUD.showWait(title: target.hudConfig.title, isClickHidden: target.hudConfig.clickCancel)
    }

    /// 收到响应后执行，这是检查的机会
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard let target = target as? CustomizeTargetType, target.hudConfig.isShow  else {
            return
        }
        HUD.hide()
    }

    /// 在completion调用前执行，这是对request的Result进行编辑的机会
    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        return result
    }

}
