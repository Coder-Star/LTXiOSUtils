//
//  APIService.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/11/28.
//

import Foundation

public typealias APICompletionHandler<T> = (APIResponse<T>) -> Void

public enum NetworkStatus {
    case unknown
    case notReachable
    case wifi
    case wwan
}

public enum APIResult<T> {
    case success(T)
    case failure(APIError)
}

open class APIService {
    private let reachabilityManager = APINetworkReachabilityManager()

    public let clinet: APIClient

    public init(clinet: APIClient) {
        self.clinet = clinet
    }

    public static let shared = APIService(clinet: AlamofireAPIClient())
}

// MARK: - 私有方法

extension APIService {
    private func performdData<T: APIRequest>(
        request: T,
        response: APIDataResponse<Data>,
        result: APIResult<T.Response>,
        plugins: [APIPlugin],
        completionHandler: @escaping APICompletionHandler<T.Response>
    ) {
        let apiResponse = APIResponse<T.Response>(request: response.request, response: response.response, data: response.data, result: result)

        plugins.forEach { $0.didReceive(apiResponse, targetRequest: request) }

        let isAllowCallback = request.intercept(response: apiResponse)

        if isAllowCallback {
            completionHandler(apiResponse)
        }
    }
}

// MARK: - 公开属性

extension APIService {
    public var networkStatus: NetworkStatus {
        guard let status = reachabilityManager?.networkReachabilityStatus else {
            return .unknown
        }
        switch status {
        case .unknown:
            return .unknown
        case .notReachable:
            return .notReachable
        case let .reachable(type):
            switch type {
            case .ethernetOrWiFi:
                return .wifi
            case .wwan:
                return .wwan
            }
        }
    }

    public var isNetworkReachable: Bool {
        return networkStatus == .wifi || networkStatus == .wwan
    }
}

// MARK: - 公开方法

extension APIService {
    @discardableResult
    public static func sendRequest<T: APIRequest>(
        _ request: T,
        plugins: [APIPlugin] = [],
        progressHandler: APIProgressHandler? = nil,
        completionHandler: @escaping APICompletionHandler<T.Response>
    ) -> APIRequestTask? {
        shared.sendRequest(request, plugins: plugins, progressHandler: progressHandler, completionHandler: completionHandler)
    }

    @discardableResult
    public func sendRequest<T: APIRequest>(
        _ request: T,
        plugins: [APIPlugin] = [],
        progressHandler: APIProgressHandler? = nil,
        completionHandler: @escaping APICompletionHandler<T.Response>
    ) -> APIRequestTask? {
        var urlRequest: URLRequest
        do {
            urlRequest = try request.buildURLRequest()
            urlRequest = plugins.reduce(urlRequest) { $1.prepare($0, targetRequest: request) }
        } catch {
            let apiResult: APIResult<T.Response> = .failure(.requestError(error))
            let apiResponse = APIResponse<T.Response>(request: nil, response: nil, data: nil, result: apiResult)
            completionHandler(apiResponse)
            return nil
        }

        if !isNetworkReachable {
            let apiResult: APIResult<T.Response> = .failure(.networkError)
            let apiResponse = APIResponse<T.Response>(request: nil, response: nil, data: nil, result: apiResult)
            completionHandler(apiResponse)
            return nil
        }
        let clinetRequest: APIRequestTask
        switch request.taskType {
        // TODO: - 需要对三个case分别处理
        case .request, .upload, .download:
            clinetRequest = clinet.createDataRequest(request: urlRequest, progressHandler: progressHandler) { [weak self] response in
                let apiResult: APIResult<T.Response>
                switch response.result {
                case let .success(data):
                    do {
                        let responseModel = try T.Response.parse(data: data)
                        apiResult = .success(responseModel)
                    } catch {
                        apiResult = .failure(.responseError(error))
                    }
                case let .failure(error):
                    apiResult = .failure(.connectionError(error))
                }

                self?.performdData(request: request, response: response, result: apiResult, plugins: plugins, completionHandler: completionHandler)
            }
        }

        plugins.forEach { $0.willSend(urlRequest, targetRequest: request) }

        clinetRequest.resume()

        return clinetRequest
    }
}
