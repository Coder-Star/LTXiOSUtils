//
//  NetworkManager.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/9/3.
//  Copyright © 2019年 李天星. All rights reserved.
//

/*
Moya内置三个插件，分别为NetworkLoggerPlugin，NetworkActivityPlugin以及CredentialsPlugin
第一个是日志、第二个是网络活动、第三个是身份验证
*/

import Foundation
import Moya
import SwiftyJSON
import Reachability

/// 生成请求闭包，将一个Endpoint分解成一个实际的URLRequest，并对URLRequest进行最后的编辑
func getRequestTimeoutClosure(timeoutInterval: TimeInterval = NetworkConfig.requestTimeOut) -> MoyaProvider<APIManager>.RequestClosure {
    let requestTimeoutClosure = { (endpoint: Endpoint, closure: @escaping MoyaProvider<APIManager>.RequestResultClosure) in
        do {
            var urlRequest = try endpoint.urlRequest()
            // 设置请求的超时时间
            urlRequest.timeoutInterval = timeoutInterval
            closure(.success(urlRequest))
        } catch MoyaError.requestMapping(let url) {
            closure(.failure(MoyaError.requestMapping(url)))
        } catch MoyaError.parameterEncoding(let error) {
            closure(.failure(MoyaError.parameterEncoding(error)))
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }
    return requestTimeoutClosure
}
/// 默认超时请求闭包
var requestTimeoutClosure = getRequestTimeoutClosure()

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
    /// 成功时进行回调，错误统一处理
    /// - Parameters:
    ///   - requestParam: 请求参数
    ///   - success: 成功回调
    public class func sendRequest(requestParam: RequestParam, success: @escaping SuccessBlock) {
        sendRequest(requestParam: requestParam, progress: { _ in

        }, success: { data in
            success(data)
        }, failure: { error in
            manageError(requestParam: requestParam, error: error) { data in
                success(data)
            }
        }
        )
    }

    /// 网络请求
    /// 成功后进行回调，返回进度，错误统一处理
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
            manageError(requestParam: requestParam, error: error) { data in
                success(data)
            }
        }
        )
    }

    /// 网络请求
    /// 成功回调、错误回调
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
    /// 包含成功、错误及进度回调
    /// - Parameters:
    ///   - requestParam: 请求参数
    ///   - progress: 进度回调
    ///   - success: 成功回调
    ///   - failure: 失败回调
    public class func sendRequest(requestParam: RequestParam, progress: @escaping ProgressBlock, success: @escaping SuccessBlock, failure: @escaping FailureBlock) {
        Log.d("请求url详细信息")
        requestParam.printInfo()

        /// 如果为本次请求设置了与默认值不同的超时时间，重新设置请求闭包
        if requestParam.timeOut != NetworkConfig.requestTimeOut {
            requestTimeoutClosure = getRequestTimeoutClosure(timeoutInterval: requestParam.timeOut)
        }

        /// 如果本次网络请求不使用默认token，则重新设置认证插件AuthPlugin
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
        var errorCode: Int = 0
        var description = "未知错误"
        if let error = moyaError {
            switch error {
            //下面四个错误是转换失败
            case .imageMapping(let response):
                errorCode = RequestErrorCode.responseImageMapping.rawValue
                Log.d(response)
            case .jsonMapping(let response):
                errorCode = RequestErrorCode.responseJSONMapping.rawValue
                Log.d(response)
            case .stringMapping(let response):
                errorCode = RequestErrorCode.responseStringMapping.rawValue
                Log.d(response)
            case .objectMapping( _, let response):
                errorCode = RequestErrorCode.responseObjectMapping.rawValue
                Log.d(response)
            case .encodableMapping:
                errorCode = RequestErrorCode.responseEncodableMapping.rawValue
            case .statusCode(let response):
                errorCode = RequestErrorCode.invalidStatusCode.rawValue
                Log.d(response)
            case .requestMapping(let str):
                errorCode = RequestErrorCode.requestMapping.rawValue
                Log.d(str)
            case .parameterEncoding:
                errorCode = RequestErrorCode.parameterEncoding.rawValue
            /// 无网络、请求的服务器不存在
            /// 当无网络时，回调的错误结果描述包含有 1、请求超时 2、网络连接已中断 3、似乎已断开与互联网的连接
            /// 当请求服务器存在，但项目路径不存在时，回调的错误结果描述为无法连接服务器
            /// 当请求服务器不存在，回调的错误结果描述为 请求超时
            case .underlying( _, let response):
                let reachability = try? Reachability()
                if reachability?.connection == .unavailable {
                    errorCode = RequestErrorCode.noNetwork.rawValue
                } else {
                    errorCode = RequestErrorCode.serverConnectFailed.rawValue
                }
                Log.d(response)
            }

            description = error.localizedDescription
            Log.d("Moya错误，错误码为: \(errorCode),错误描述为: \(description)")
        } else if let statusCode = statusCode {
            errorCode = statusCode
            description = ""
            Log.d("Http状态码错误，状态码为: \(statusCode)")
        }
        return RequestError(errorCode: errorCode, description: description)
    }

    /// 统一处理错误
    /// - Parameter error: 错误
    public class func manageError(requestParam: RequestParam, error: RequestError, success: @escaping SuccessBlock) {
        let retryCount = requestParam.retryCount
        if retryCount > 0 {
            let retryRequestParam = requestParam
            retryRequestParam.retryCount = retryCount - 1
            sendRequest(requestParam: retryRequestParam) { data in
                success(data)
            }
            return
        }
        if requestParam.ignoreError {
            return
        }
        let errorCode = error.errorCode
        var errorInfo = "内部错误"
        if errorCode == RequestErrorCode.serverConnectFailed.rawValue {
            errorInfo = "服务器连接失败"
        } else if errorCode == RequestErrorCode.noNetwork.rawValue {
            errorInfo = "似乎已断开与网络的连接"
        }
        errorInfo += "(\(errorCode))"
        HUD.showText(errorInfo)
    }

}

/// 请求错误
public struct RequestError {
    /// 错误码
    public var errorCode: Int
    /// 错误描述
    public var description: String
}

/// 请求错误描述
public enum RequestErrorCode: Int {
// MARK: - response转换失败
    /// 返回数据无法转换为image
    case responseImageMapping = -1000
    /// 返回数据无法转换为json
    case responseJSONMapping = -1001
    /// 返回数据无法转换为字符串
    case responseStringMapping = -1002
    /// 返回数据无法转换为对象
    case responseObjectMapping = -1003
    /// 返回数据无法转换Data
    case responseEncodableMapping = -1004

// MARK: - 请求错误
    /// 端点到请求之间转换失败
    case requestMapping = -1005
    /// 参数编码错误
    case parameterEncoding = -1006

// MARK: - 其他错误
    /// 无效状态码
    case invalidStatusCode = -1007
    /// 服务器连接失败
    case serverConnectFailed = -1008
    /// 无网络或网络连接失败
    case noNetwork = -1009
}
