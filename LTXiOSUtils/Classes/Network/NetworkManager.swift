//
//  NetworkManager.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/9/3.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

var requestTimeoutClosure = { (endpoint: Endpoint, closure: @escaping MoyaProvider<APIManager>.RequestResultClosure) in
    do {
        var urlRequest = try endpoint.urlRequest()
        urlRequest.timeoutInterval = NetworkConfig.requestTimeOut
        closure(.success(urlRequest))
    } catch MoyaError.requestMapping(let url) {
        closure(.failure(MoyaError.requestMapping(url)))
    } catch MoyaError.parameterEncoding(let error) {
        closure(.failure(MoyaError.parameterEncoding(error)))
    } catch {
        closure(.failure(MoyaError.underlying(error, nil)))
    }
}

/*
 Moya内置三个插件，分别为NetworkLoggerPlugin，NetworkActivityPlugin以及CredentialsPlugin
 第一个是日志、第二个是网络活动、第三个是身份验证
 */

/// 默认的MoyaProvider
var provider = MoyaProvider<APIManager>(requestClosure: requestTimeoutClosure, plugins: [LoadingPlugin(), AuthPlugin()])

/// 网络请求工具类
public class NetworkManager {
    /// 成功回调闭包
    public typealias SuccessBlock = (_ data: JSON) -> Void
     /// 进度回调闭包
    public typealias ProgressBlock = (_ progressResponse: ProgressResponse) -> Void
     /// 失败回调闭包
    public typealias FailureBlock = (_ st: RequestError) -> Void

    /// 网络请求
    ///
    /// - Parameters:
    ///   - requestParam: 请求参数
    ///   - success: 成功回调
    public class func sendRequest(requestParam: RequestParam, success:@escaping(_ data: JSON) -> Void) {
        sendRequest(requestParam: requestParam, progress: { _ in

        }, success: { data in
            success(data)
        }, failure: { error  in
            manageError(error: error)
        }
        )
    }

    /// 网络请求
    ///
    /// - Parameters:
    ///   - requestParam: 请求参数
    ///   - progress: 进度回调
    ///   - success: 成功回调
    public class func sendRequest(requestParam: RequestParam, progress: @escaping ProgressBlock, success: @escaping SuccessBlock) {
        sendRequest(requestParam: requestParam, progress: { resultProgress in
            progress(resultProgress)
        }, success: { data in
            success(data)
        }, failure: { error in
            manageError(error: error)
        }
        )
    }

    /// 网络请求
    ///
    /// - Parameters:
    ///   - requestParam: 请求参数
    ///   - success: 成功回调
    ///   - failure: 失败回调
    public class func sendRequest(requestParam: RequestParam, success: @escaping SuccessBlock, failure: @escaping FailureBlock) {
        sendRequest(requestParam: requestParam, progress: { _ in

        }, success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        }
        )
    }

    /// 网络请求，最基本的
    /// - Parameters:
    ///   - requestParam: 请求参数
    ///   - progress: 进度回调
    ///   - success: 成功回调
    ///   - failure: 失败回调
    public class func sendRequest(requestParam: RequestParam, progress: @escaping ProgressBlock, success: @escaping SuccessBlock, failure: @escaping FailureBlock) {
        Log.d("请求url详细信息")
        requestParam.printInfo()

        if requestParam.timeOut != NetworkConfig.requestTimeOut {
            requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<APIManager>.RequestResultClosure) in
                do {
                    var request = try endpoint.urlRequest()
                    request.timeoutInterval = requestParam.timeOut
                    done(.success(request))
                } catch {
                    Log.e("错误信息:\(error)")
                    return
                }
            }
        }

        if requestParam.token.isNotEmpty {
            var authPlugin = AuthPlugin()
            authPlugin.token = requestParam.token
            provider = MoyaProvider<APIManager>(requestClosure: requestTimeoutClosure, plugins: [LoadingPlugin(), authPlugin])
        }

        provider.request(.getData(requestParam:requestParam), progress: { resultProgress in
            progress(resultProgress)
        }, completion: { result in
            switch result {
            case let .success(response):
                Log.d("状态码: \(response.statusCode)")
                do {
                    let successResponse = try response.filterSuccessfulStatusCodes()
                    let data = JSON(successResponse.data)
                    success(data)
                } catch {
                    failure(mergeError(statusCode: response.statusCode, moyaError: nil))
                }

            case let .failure(error):
                failure(mergeError(statusCode: nil, moyaError: error))
            }
        }
        )
    }

    /// 取消所有网络请求
    public class func cancelAllRequest() {
        provider.manager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }

    /// 合并错误
    /// - Parameters:
    ///   - statusCode: 状态码
    ///   - moyaError: Moya的错误
    public class func mergeError(statusCode: Int?, moyaError: MoyaError?) -> RequestError {
        var code: Int = -1
        var description = ""
        if let error = moyaError {
            description = error.localizedDescription

            Log.d("HTTP请求状态码：\(String(describing: error.response?.statusCode))")
            Log.d("错误原因：\(error.errorDescription ?? "")")
            Log.d(error.errorCode)
            Log.d(error.failureReason as Any)
            Log.d(error.localizedDescription)
//            switch error {
//            //下面四个错误是转换失败
//            case .imageMapping(let response):
//                Log.d(response)
//            case .jsonMapping(let response):
//                Log.d(response)
//            case .stringMapping(let response):
//                Log.d(response)
//            case .objectMapping(let error, let response):
//                Log.d(error)
//                Log.d(response)
//            case .encodableMapping(let error):
//                Log.d(error)
//            case .statusCode(let response): //状态码不在范围内
//                Log.d(response)
//            case .underlying(let error, let response): //没有网络时 、 服务器不存在
//                Log.d(error.localizedDescription)
//                Log.d(response as Any)
//            case .requestMapping(let str): //请求操作
//                Log.d(str)
//            case .parameterEncoding(let error): // 参数错误
//                Log.d(error)
//            }
        } else if let statusCode = statusCode {
            code = statusCode
            description = ""
        }
        return RequestError(statusCode: code, description: description)
    }

    /// 处理错误
    /// - Parameter error: 错误
    public class func manageError(error: RequestError) {

    }

}

/// 请求错误
public struct RequestError {
    /// Http请求状态码
    public var statusCode: Int
    /// 错误描述
    public var description: String

}
