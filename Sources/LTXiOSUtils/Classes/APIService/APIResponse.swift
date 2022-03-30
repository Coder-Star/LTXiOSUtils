//
//  APIResponseModel.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/4.
//

import Foundation

public struct APIResponse<T> {
    /// 请求
    public var request: URLRequest?

    /// 回调
    public var response: HTTPURLResponse?

    /// 数据
    public var data: Data?

    /// 解析后数据
    public var result: APIResult<T>

    public init(request: URLRequest?,
                response: HTTPURLResponse?,
                data: Data?,
                result: APIResult<T>) {
        self.request = request
        self.response = response
        self.data = data
        self.result = result
    }
}

extension APIResponse {
    public var statusCode: Int? {
        return response?.statusCode
    }
}
