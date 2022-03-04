//
//  APIResponseModel.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/4.
//

import Foundation

protocol APIResponseModel: APIParsable {
    var code: Int { get set }
    var msg: String { get set }
    var data: DataType { get set }

    var isSuccess: Bool { get }

    associatedtype DataType
}

public struct DefaultAPIResponseModel<T>: APIResponseModel & APIParsable & Decodable where T: APIParsable & Decodable {
    public var code: Int
    public var msg: String
    public var data: T?

    var isSuccess: Bool {
        return code == 200
    }

    public static func parse(data: Data) -> APIResult<DefaultAPIResponseModel<T>> {
        do {
            let model = try JSONDecoder().decode(self, from: data)
            return .success(model)
        } catch {
            return .failure(error)
        }
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
