//
//  DescBaseResponseModel.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2022/3/16.
//

import Foundation

public struct CSBaseResponseModel<T>: APIParsable & Decodable where T: APIParsable & Decodable {
    public var code: Int
    public var desc: String
    public var data: T?
}
