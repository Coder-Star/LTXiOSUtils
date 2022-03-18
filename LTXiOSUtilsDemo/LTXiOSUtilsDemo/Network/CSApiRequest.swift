//
//  CSApiRequest.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2022/3/16.
//

import Foundation

public struct CSApiRequest<T: APIParsable>: APIRequest {
    public var url: String

    public var method: NetRequestMethod

    public var parameters: [String: Any]?

    public var headers: NetRequestHeaders?

    public var httpBody: Data?

    public typealias Response = T
}

extension CSApiRequest {
    public init(responseType: Response.Type, url: String, method: NetRequestMethod = .get) {
        self.url = NetworkConstants.baseURL + "/" + (url.hasPrefix("/") ? String(url.dropFirst()) : url)
        self.method = method
    }
}

extension CSApiRequest {
    public init<S>(dataType: S.Type, url: String, method: NetRequestMethod = .get) where CSBaseResponseModel<S> == T {
        self.init(responseType: CSBaseResponseModel<S>.self, url: url, method: method)
    }
}
