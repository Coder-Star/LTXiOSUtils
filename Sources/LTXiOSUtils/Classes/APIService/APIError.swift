//
//  APIError.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/25.
//

import Foundation

public enum APIError: LocalizedError, Equatable {
    case networkError

    /// 发送错误
    case requestError(Error)

    /// 连接错误
    case connectionError(Error)

    /// 接收错误
    /// 解析等步骤
    case responseError(Error)

    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        return lhs.errorCode == rhs.errorCode
    }

    public var errorDescription: String? {
        switch self {
        case let .requestError(error):
            return "发出请求错误（\(error.localizedDescription)）"
        case let .connectionError(error):
            return "请求错误（\(error.localizedDescription)）"
        case let .responseError(error):
            return "结果处理错误（\(error.localizedDescription)）"
        case .networkError:
            return "当前网络不可用"
        }
    }

    public var errorCode: Int {
        switch self {
        case let .requestError(error):
            return 1
        case let .connectionError(error):
            return 2
        case let .responseError(error):
            return 3
        case .networkError:
            return 4
        }
    }
}

public enum APIRequestError: LocalizedError {
    case invalidURLRequest

    public var errorDescription: String? {
        switch self {
        case let .invalidURLRequest:
            return "不合理的请求链接"
        }
    }
}

public enum APIResponseError: LocalizedError {
    case invalidParseResponse(Error)

    public var errorDescription: String? {
        switch self {
        case let .invalidParseResponse(error):
            return error.localizedDescription
        }
    }
}
