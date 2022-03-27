//
//  DescBaseResponseModel.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2022/3/16.
//

import Foundation
import LTXiOSUtils

public struct CSBaseResponseModel<T>: APIModelWrapper, APIDefaultJSONParsable where T: APIJSONParsable & Decodable {
    public var code: Int
    public var msg: String
    public var data: T?

    enum CodingKeys: String, CodingKey {
        case code
        case msg = "desc"
        case data
    }
}

extension DefaultAPIRequest {
    public init<S>(path: String, dataType: S.Type) where CSBaseResponseModel<S> == T {
        self.init(baseURL: NetworkConstants.baseURL, path: path, dataType: dataType)
    }
}
