//
//  APIModelWrapper.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/27.
//

import Foundation

public protocol APIModelWrapper {
    associatedtype DataType: APIParsable

    var code: Int { get }

    var msg: String { get }

    var data: DataType? { get }
}

// public struct DefaultAPIResponseModel<T>: APIModelWrapper, APIDefaultJSONParsable where T: APIJSONParsable & Decodable {
//    public var code: Int
//    public var msg: String
//    public var data: T?
// }
