//
//  APIServiceDelegate.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/3.
//

import Foundation

public protocol APIClientDelegate {
    /// 发送之前
    func beforeSend<T: APIRequest>(request: T) -> T

    /// 发送之后
    func afterSend<T: APIRequest>(request: T)

    /// 接收之前
    func beforeResponse<T>(response: APIResponse<T>) -> APIResponse<T>

    /// 接收之后
    func afterResponse<T>(response: APIResponse<T>)
}

extension APIClientDelegate {
    /// 发送之前
    public func beforeSend<T: APIRequest>(request: T) -> T {
        return request
    }

    /// 发送之后
    public func afterSend<T: APIRequest>(request: T) {}

    /// 接收之前
    public func beforeResponse<T>(response: APIResponse<T>) -> APIResponse<T> {
        return response
    }

    /// 接收之后
    public func afterResponse<T>(response: APIResponse<T>) {}
}

/// 统一的管理器
public class APIClientDelegateManager {
    public static let shared = APIClientDelegateManager()

    var delegate: APIClientDelegate?

    private init() {}

    private var delegateMap: [String: APIClientDelegate] = [:]

    public func addDelegate<T>(delegate: T) where T: APIClientDelegate {
        delegateMap["\(type(of: delegate))"] = delegate
    }

    public func removeDelegate<T>(delegate: T) where T: APIClientDelegate {
        delegateMap.removeValue(forKey: "\(type(of: delegate))")
    }
}
