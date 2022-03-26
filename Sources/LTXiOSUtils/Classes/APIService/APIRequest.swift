//
//  APIRequest.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/4.
//

import Foundation

public enum APIRequestTaskType {
    case request
    case upload
    case download
}

public protocol APIRequest {
    /// 回调实体
    associatedtype Response: APIParsable

    /// 基础地址
    var baseURL: URL { get }

    /// 接口路径
    var path: String { get }

    /// 方法
    var method: APIRequestMethod { get }

    /// 参数
    var parameters: [String: Any]? { get }

    /// header
    var headers: APIRequestHeaders? { get }

    var taskType: APIRequestTaskType { get }

    var encoding: APIParameterEncoding { get }

    /// 拦截urlRequest
    /// 对其加上额外的统一参数，比如token等
    func intercept(urlRequest: URLRequest) throws -> URLRequest

    func intercept(response: APIResponse<Response>)
}

extension APIRequest {
    public func intercept(urlRequest: URLRequest) throws -> URLRequest {
        return urlRequest
    }

    public func intercept(response: APIResponse<Response>) {}
}

extension APIRequest {
    var completeURL: URL {
        return path.isEmpty ? baseURL : baseURL.appendingPathComponent(path)
    }

    func buildURLRequest() throws -> URLRequest {
        do {
            let originalRequest = try URLRequest(url: completeURL, method: method, headers: headers)
            let encodedURLRequest = try encoding.encode(originalRequest, with: parameters)
            return try intercept(urlRequest: encodedURLRequest)
        } catch {
            throw (APIRequestError.invalidURLRequest)
        }
    }
}

// MARK: - 默认实现

public struct DefaultAPIRequest<T: APIParsable>: APIRequest {
    public var baseURL: URL

    public var path: String

    public var method: APIRequestMethod = .get

    public var parameters: [String: Any]?

    public var headers: APIRequestHeaders?

    public var httpBody: Data?

    public var taskType: APIRequestTaskType = .request

    public var encoding: APIParameterEncoding = APIURLEncoding.default

    public typealias Response = T
}

extension DefaultAPIRequest {
    public init(baseURL: URL, path: String, responseType: Response.Type) {
        self.baseURL = baseURL
        self.path = path
    }
}

// MARK: 默认最外层Model

public struct DefaultAPIResponseModel<T>: APIParsable & Decodable where T: APIParsable & Decodable {
    public var code: Int
    public var msg: String
    public var data: T?

    public var isSuccess: Bool {
        return code == 200
    }
}

extension DefaultAPIRequest {
    public init<S>(baseURL: URL, path: String, dataType: S.Type) where DefaultAPIResponseModel<S> == T {
        self.init(baseURL: baseURL, path: path, responseType: DefaultAPIResponseModel<S>.self)
    }
}
