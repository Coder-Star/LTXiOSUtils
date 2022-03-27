//
//  APIError.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/25.
//

import Foundation

public enum APIError: Error {
    /// 发送错误
    case requestError(Error)

    /// 连接错误
    case connectionError(Error)

    /// 接收错误
    /// 解析等步骤
    case responseError(Error)
}

public enum APIRequestError: Error {
    case invalidURLRequest
}

public enum APIResponseError: Error {
    case invalidParseResponse(Error)
    case invalidParseResponseData
}
