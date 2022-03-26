//
//  APIPlugin.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/26.
//

import Foundation

public protocol APIPlugin {
    func prepare<T: APIRequest>(_ request: URLRequest, targetRequest: T) -> URLRequest

    func willSend<T: APIRequest>(_ request: URLRequest, targetRequest: T)

    func didReceive<T: APIRequest>(_ result: APIResponse<T.Response>, targetRequest: T)
}
