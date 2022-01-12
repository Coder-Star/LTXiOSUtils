//
//  APIService.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/11/28.
//

import Alamofire
import Foundation

protocol APIServiceDelegate {
    func beforeSendRequest()
    func afterSendRequest()
    func afterResponse()
}

class APIServiceDelegateManager: APIServiceDelegate {
    public static let shared = APIServiceDelegateManager()
    func beforeSendRequest() {}

    func afterSendRequest() {}

    func afterResponse() {}
}

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
    public static func sendRequest<T>(url: String, success: @escaping SuccessClosure<T>) {
        AF.request(url).validate().responseJSON { reponse in
            switch reponse.result {
            case let .success(data):

                break
            case let .failure(error):
                break
            }
        }
    }
}
