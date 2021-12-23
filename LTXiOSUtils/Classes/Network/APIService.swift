//
//  APIService.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/11/28.
//

import Foundation

public struct BaseResponse<T> {
    public var data: T
    public var code: Int
}

public protocol APIResponseModel {
    associatedtype Response: Decodable
}

public struct APIService {
    /// 成功回调闭包
    public typealias SuccessClosure<T> = (_ data: T) -> Void
}

extension APIService {
//    public static func sendRequest<T>(requestParam: RequestParam, success: @escaping SuccessClosure<T>) {
//        guard let data: T = try? JSONDecoder.dec
//    }
}
