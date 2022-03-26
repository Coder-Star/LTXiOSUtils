//
//  APIClient.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/4.
//

import Foundation

public typealias APIDataResponseCompletionHandler = (APIDataResponse<Data>) -> Void

public protocol APIClient {
    func createRequest(request: URLRequest, completionHandler: @escaping APIDataResponseCompletionHandler) -> APIDataRequest
}
