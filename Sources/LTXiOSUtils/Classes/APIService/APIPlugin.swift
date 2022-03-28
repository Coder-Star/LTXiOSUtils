//
//  APIPlugin.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/26.
//

import Foundation

public protocol APIPlugin {
    /// 构造URLRequest
    func prepare<T: APIRequest>(_ request: URLRequest, targetRequest: T) -> URLRequest

    /// 发送之前
    func willSend<T: APIRequest>(_ request: URLRequest, targetRequest: T)

    /// 接收结果，时机在返回给调用方之前
    func didReceive<T: APIRequest>(_ result: APIResponse<T.Response>, targetRequest: T)
}
