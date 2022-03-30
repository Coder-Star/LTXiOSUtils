//
//  NetworkDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2022/3/16.
//

import BetterCodable
import Foundation
import LTXiOSUtils

typealias BannerDataCallback = ((HomeBanner?, Error?) -> Void)

public enum APIValidateResult<T> {
    case success(T, String)
    case failure(String, APIError)
}

public enum CSDataError: Error {
    case invalidParseResponse
}

extension APIResult where T: APIModelWrapper {
    var validateResult: APIValidateResult<T.DataType> {
        var message = "出现错误，请稍后重试"
        switch self {
        case let .success(reponse):
            if reponse.code == 200, reponse.data != nil {
                return .success(reponse.data!, reponse.msg)
            } else {
                return .failure(message, APIError.responseError(APIResponseError.invalidParseResponse(CSDataError.invalidParseResponse)))
            }
        case let .failure(apiError):
            if apiError == APIError.networkError {
                message = apiError.localizedDescription
            }

            assertionFailure(apiError.localizedDescription)
            return .failure(message, apiError)
        }
    }
}

class NetworkDemoViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        getHomeBannerData { _, _ in
        }
    }

    private func getHomeBannerData(callback: @escaping BannerDataCallback) {
        let request = DefaultAPIRequest(csPath: "/config/homeBanner", dataType: HomeBanner.self)

        APIService.sendRequest(request) { reponse in
            Log.d(reponse.result)

            switch reponse.result.validateResult {
            case let .success(info, _):
                Log.d(info)
            case let .failure(_, error):
                Log.d(error)
            }
        }
    }
}

struct HomeBanner: APIDefaultJSONParsable {
    var interval: Int

    @DefaultCodable<DefaultEmptyString>
    var info: String

    @DefaultCodable<DefaultEmptyArray>
    var imageList: [ImageList]
}

struct ImageList: Decodable {
    var imgUrl: String
    var actionUrl: String
}

public struct DefaultEmptyString: DefaultCodableStrategy {
    public static var defaultValue: String { "" }
}

public struct DefaultEmptyArray<T>: DefaultCodableStrategy where T: Decodable {
    public static var defaultValue: [T] { [] }
}

public struct DefaultEmptyDict<K, V>: DefaultCodableStrategy where K: Hashable & Codable, V: Codable {
    public static var defaultValue: [K: V] { [:] }
}
