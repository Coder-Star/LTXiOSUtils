//
//  APIService.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/11/28.
//

import Foundation

public typealias APICompletionHandler<T> = (APIResponse<T>) -> Void

/// 网络状态
public enum NetworkStatus {
    /// 未知
    case unknown
    /// 不可用
    case notReachable
    /// wifi
    case wifi
    /// 数据
    case wwan
}

/// 结果
public enum APIResult<T> {
    case success(T)
    case failure(APIError)
}

// MARK: - APIService

open class APIService {
    private let reachabilityManager = APINetworkReachabilityManager()

    public let clinet: APIClient

    public init(clinet: APIClient) {
        self.clinet = clinet
    }

    /// 单例
    public static let shared = APIService(clinet: AlamofireAPIClient())
}

// MARK: - 私有方法

extension APIService {
    /// 回调数据给调用方
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 上层回来的数据
    ///   - result: 结果
    ///   - plugins: 插件
    ///   - completionHandler: 结果回调
    /// - Returns: 请求任务
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
    /// 网络状态
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

    /// 网络是否可用
    public var isNetworkReachable: Bool {
        return networkStatus == .wifi || networkStatus == .wwan
    }
}

// MARK: - 公开方法

extension APIService {
    /// 创建数据请求
    /// 这种方式使用为 Alamofire 作为底层实现
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - plugins: 插件
    ///   - progressHandler: 进度回调
    ///   - completionHandler: 结果回调
    /// - Returns: 请求任务
    @discardableResult
    public static func sendRequest<T: APIRequest>(
        _ request: T,
        plugins: [APIPlugin] = [],
        progressHandler: APIProgressHandler? = nil,
        completionHandler: @escaping APICompletionHandler<T.Response>
    ) -> APIRequestTask? {
        shared.sendRequest(request, plugins: plugins, progressHandler: progressHandler, completionHandler: completionHandler)
    }

    /// 创建数据请求
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - plugins: 插件
    ///   - progressHandler: 进度回调
    ///   - completionHandler: 结果回调
    /// - Returns: 请求任务
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
