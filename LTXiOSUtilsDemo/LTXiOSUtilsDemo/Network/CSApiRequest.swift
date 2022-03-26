//
//  CSApiRequest.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2022/3/16.
//

import Foundation
import LTXiOSUtils

public struct CSApiRequest<T: APIParsable>: APIRequest {
    public var baseURL: URL = NetworkConstants.baseURL

    public var path: String

    public var method: APIRequestMethod = .get

    public var parameters: [String: Any]?

    public var headers: APIRequestHeaders?

    public var taskType: APIRequestTaskType = .request

    public var encoding: APIParameterEncoding {
        if method == .get {
            return APIURLEncoding.default
        } else {
            return APIJSONEncoding.default
        }
    }

    public typealias Response = T
}

extension CSApiRequest {
    public init(path: String, responseType: Response.Type) {
        self.path = path
    }
}

extension CSApiRequest {
    public init<S>(path: String, dataType: S.Type) where CSBaseResponseModel<S> == T {
        self.init(path: path, responseType: CSBaseResponseModel<S>.self)
    }
}
