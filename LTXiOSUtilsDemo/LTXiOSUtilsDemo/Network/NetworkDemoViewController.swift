//
//  NetworkDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2022/3/16.
//

import Foundation
import LTXiOSUtils

typealias BannerDataCallback = ((HomeBanner?, Error?) -> Void)

struct APIValidateResult<T> {
    var isRight: Bool
    var message: String
    var data: T?
}

extension APIResult where T: APIModelWrapper {
    var validateResult: APIValidateResult<T.DataType> {
        var message = "出现错误，请稍后重试"
        var data: T.DataType?
        var isRight = false
        switch self {
        case let .success(reponse):
            if reponse.code == 200 {
                isRight = true
                data = reponse.data
            }
            message = reponse.msg

        case let .failure(apiError):
            if apiError == APIError.networkError {
                message = "当前网络不可用"
            }
        }

        return APIValidateResult(isRight: isRight, message: message, data: data)
    }
}

class NetworkDemoViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        getHomeBannerData { _, _ in
        }
    }

    private func getHomeBannerData(callback: @escaping BannerDataCallback) {
        let request = DefaultAPIRequest(path: "/config/homeBanner", dataType: HomeBanner.self)

        APIService.sendRequest(request) { reponse in
            let validateResult = reponse.result.validateResult
            if validateResult.isRight {
                Log.d(validateResult.data)
            }
        }
    }
}

struct HomeBanner: APIDefaultJSONParsable {
    var interval: Int = 0
}
