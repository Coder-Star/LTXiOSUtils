//
//  APIError.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/25.
//

import Foundation

public enum APIError: Error {
    /// 连接错误
    case connectionError(Error)

    /// 发送错误
    case requestError(Error)

    /// 接收错误
    case responseError(Error)

    /// 解析错误
    case parseError(Error)
}

public enum APIRequestError: Error {
    case invalidURLRequest
}
