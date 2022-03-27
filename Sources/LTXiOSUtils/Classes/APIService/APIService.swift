//
//  APIService.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/11/28.
//

import Foundation

public typealias APICompletionHandler<T> = (APIResponse<T>) -> Void

public enum APIResult<T> {
    case success(T)
    case failure(Error)
}

open class APIService {
    private let reachabilityManager = APINetworkReachabilityManager()

    public let clinet: APIClient

    public init(clinet: APIClient) {
        self.clinet = clinet
    }

    public static let shared = APIService(clinet: AlamofireAPIClient())
}

extension APIService {}

extension APIService {
    @discardableResult
    static public func sendRequest<T: APIRequest>(_ request: T, plugins: [APIPlugin] = [], completionHandler: @escaping APICompletionHandler<T.Response>) -> APIDataRequest? {
        shared.sendRequest(request, plugins: plugins, completionHandler: completionHandler)
    }

    @discardableResult
    public func sendRequest<T: APIRequest>(_ request: T, plugins: [APIPlugin] = [], completionHandler: @escaping APICompletionHandler<T.Response>) -> APIDataRequest? {
        var urlRequest: URLRequest
        do {
            urlRequest = try request.buildURLRequest()
            urlRequest = plugins.reduce(urlRequest) { $1.prepare($0, targetRequest: request) }
        } catch {
            let apiResult: APIResult<T.Response> = .failure(APIError.requestError(error))
            let apiResponse = APIResponse<T.Response>(request: nil, response: nil, data: nil, result: apiResult)
            completionHandler(apiResponse)
            return nil
        }

        let clinetRequest = clinet.createRequest(request: urlRequest) { response in
            let apiResult: APIResult<T.Response>
            switch response.result {
            case let .success(data):
                do {
                    let responseModel = try T.Response.parse(data: data)
                    apiResult = .success(responseModel)
                } catch {
                    apiResult = .failure(APIError.requestError(error))
                }
            case let .failure(error):
                apiResult = .failure(APIError.responseError(error))
            }

            let apiResponse = APIResponse<T.Response>(request: response.request, response: response.response, data: response.data, result: apiResult)

            plugins.forEach { $0.didReceive(apiResponse, targetRequest: request) }

            request.intercept(response: apiResponse)

            completionHandler(apiResponse)
        }

        plugins.forEach { $0.willSend(urlRequest, targetRequest: request) }

        clinetRequest.resume()

        return clinetRequest
    }
}

// TODO: - 待实现
extension APIService {
    public func sendUploadRequest() {}

    public func sendDownloadRequest() {}
}
