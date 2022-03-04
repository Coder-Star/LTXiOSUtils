//
//  APIService.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/11/28.
//

import Foundation

public enum APIError: Error {
    case unknown

    case invalidURL
}

public enum APIResult<T> {
    case success(T)
    case failure(Error)
}

public struct APIService {
    /// 每次都会生成一个新的实例
    /// 对外提供的API收口到APIService，后续想更换实现只需要替换 Client实现就ok
    public static var `default`: APIClient {
        return AlamofireAPIClient()
    }
}
