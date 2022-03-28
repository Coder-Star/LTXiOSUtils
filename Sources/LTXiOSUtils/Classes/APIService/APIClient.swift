//
//  APIClient.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/4.
//

import Foundation

public typealias APIDataResponseCompletionHandler = (APIDataResponse<Data>) -> Void
public typealias APIProgressHandler = (Progress) -> Void

public protocol APIRequestTask {
    func resume()
    func cancel()
}

public protocol APIClient {
    func createDataRequest(request: URLRequest, progressHandler: APIProgressHandler?, completionHandler: @escaping APIDataResponseCompletionHandler) -> APIRequestTask
}
