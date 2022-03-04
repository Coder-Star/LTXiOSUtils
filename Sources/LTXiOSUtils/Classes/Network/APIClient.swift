//
//  APIClient.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/4.
//

import Alamofire
import Foundation

public typealias APICompletionHandler<T> = (APIResponse<T>) -> Void

public protocol APIClient {
    var delegate: APIClientDelegate? { get }

    func send<T: APIRequest>(request: T, completionHandler: @escaping APICompletionHandler<T.Response>)
}

struct AlamofireAPIClient: APIClient {
    public var delegate: APIClientDelegate?

    public func send<T>(request: T, completionHandler: @escaping APICompletionHandler<T.Response>) where T: APIRequest {
        var resultRequest = APIClientDelegateManager.shared.delegate?.beforeSend(request: request) ?? request

        resultRequest = delegate?.beforeSend(request: resultRequest) ?? resultRequest

        AF.request(resultRequest.url,
                   method: resultRequest.method,
                   parameters: resultRequest.parameters,
                   headers: resultRequest.headers).validate().responseData { response in

            let apiResult: APIResult<T.Response>
            switch response.result {
            case let .success(data):
                let parseResult = T.Response.parse(data: data)
                switch parseResult {
                case let .success(model):
                    apiResult = .success(model)
                case let .failure(error):
                    apiResult = .failure(error)
                }
            case let .failure(error):
                apiResult = .failure(error)
            }

            let apiResponse = APIResponse<T.Response>(request: response.request, response: response.response, data: response.data, result: apiResult)

            var resultResponse = APIClientDelegateManager.shared.delegate?.beforeResponse(response: apiResponse) ?? apiResponse
            resultResponse = delegate?.beforeResponse(response: resultResponse) ?? resultResponse

            completionHandler(resultResponse)

            APIClientDelegateManager.shared.delegate?.afterResponse(response: resultResponse)
            delegate?.afterResponse(response: resultResponse)
        }
        APIClientDelegateManager.shared.delegate?.afterSend(request: resultRequest)
        delegate?.afterSend(request: resultRequest)
    }
}

struct URLSessionClient: APIClient {
    public var delegate: APIClientDelegate?

    public func send<T>(request: T, completionHandler: @escaping APICompletionHandler<T.Response>) where T: APIRequest {
        var resultRequest = APIClientDelegateManager.shared.delegate?.beforeSend(request: request) ?? request

        resultRequest = delegate?.beforeSend(request: resultRequest) ?? resultRequest

        guard let url = URL(string: resultRequest.url) else {
            completionHandler(APIResponse<T.Response>(request: nil, response: nil, data: nil, result: .failure(APIError.invalidURL)))
            return
        }
        var req = URLRequest(url: url)
        req.httpMethod = resultRequest.method.rawValue
        req.httpBody = resultRequest.httpBody
        req.allHTTPHeaderFields = resultRequest.headers?.dictionary

        URLSession.shared.dataTask(with: req) { data, _, error in
            var apiResult: APIResult<T.Response>
            if let data = data {
                let parseResult = T.Response.parse(data: data)
                switch parseResult {
                case let .success(model):
                    apiResult = .success(model)
                case let .failure(error):
                    apiResult = .failure(error)
                }
            } else if let error = error {
                apiResult = .failure(error)
            }
            apiResult = .failure(APIError.unknown)

            let apiResponse = APIResponse<T.Response>(request: req, response: nil, data: data, result: apiResult)

            var resultResponse = APIClientDelegateManager.shared.delegate?.beforeResponse(response: apiResponse) ?? apiResponse
            resultResponse = delegate?.beforeResponse(response: resultResponse) ?? resultResponse

            completionHandler(resultResponse)

            APIClientDelegateManager.shared.delegate?.afterResponse(response: resultResponse)
            delegate?.afterResponse(response: resultResponse)
        }

        APIClientDelegateManager.shared.delegate?.afterSend(request: resultRequest)
        delegate?.afterSend(request: resultRequest)
    }
}
