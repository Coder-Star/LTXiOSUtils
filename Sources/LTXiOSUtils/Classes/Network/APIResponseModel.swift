//
//  APIResponseModel.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/4.
//

import Foundation

public struct DefaultAPIResponseModel<T>: APIParsable & Decodable where T: APIParsable & Decodable {
    public var code: Int
    public var msg: String
    public var data: T?

    public var isSuccess: Bool {
        return code == 200
    }
}

public struct APIResponse<T> {
    public var request: URLRequest?
    public var response: HTTPURLResponse?
    public var data: Data?
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
