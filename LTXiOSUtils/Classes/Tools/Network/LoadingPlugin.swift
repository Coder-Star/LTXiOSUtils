//
//  NetworkRequestAlertPlugin.swift
//  LTXiOSUtils
//  等待框插件
//  Created by 李天星 on 2019/9/4.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation
import Moya
import Result

public class LoadingPlugin: PluginType {
    /// 准备网络请求
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }

    /// 即将发送网络请求
    public func willSend(_ request: RequestType, target: TargetType) {
        guard let target = target as? CustomizeTargetType, target.hudConfig.isShow else {
            return
        }
        HUD.showWait(title: target.hudConfig.title, isClickHidden: target.hudConfig.clickCancel)
    }

    /// 收到数据
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard let target = target as? CustomizeTargetType, target.hudConfig.isShow  else {
            return
        }
        HUD.hide()
    }

    /// 请求进度
    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        return result
    }

}
