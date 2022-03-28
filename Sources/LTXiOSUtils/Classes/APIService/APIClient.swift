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
    /// 发送
    func resume()
    /// 取消
    func cancel()
}

public protocol APIClient {
    /// 创建数据请求
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - progressHandler: 进度回调
    ///   - completionHandler: 结果回调
    /// - Returns: 请求任务
    func createDataRequest(
        request: URLRequest,
        progressHandler: APIProgressHandler?,
        completionHandler: @escaping APIDataResponseCompletionHandler
    ) -> APIRequestTask
}
