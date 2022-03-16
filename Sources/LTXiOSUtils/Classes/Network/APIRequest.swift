//
//  APIRequest.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/4.
//

import Alamofire
import Foundation

public typealias NetRequestMethod = HTTPMethod
public typealias NetRequestHeaders = HTTPHeaders

public protocol APIRequest {
    var url: String { get set }
    var method: NetRequestMethod { get set }
    var parameters: [String: Any]? { get set }
    var headers: NetRequestHeaders? { get set }
    var httpBody: Data? { get set }

    associatedtype Response: APIParsable
}

public struct DefaultAPIRequest<T: APIParsable>: APIRequest {
    public var url: String

    public var method: NetRequestMethod

    public var parameters: [String: Any]?

    public var headers: NetRequestHeaders?

    public var httpBody: Data?

    public typealias Response = T
}

extension DefaultAPIRequest {
    public init(responseType: Response.Type, url: String, method: NetRequestMethod = .get) {
        self.url = url
        self.method = method
    }
}

extension DefaultAPIRequest {
    public init<S>(dataType: S.Type, url: String, method: NetRequestMethod = .get) where DefaultAPIResponseModel<S> == T {
        self.init(responseType: DefaultAPIResponseModel<S>.self, url: url, method: method)
    }
}
