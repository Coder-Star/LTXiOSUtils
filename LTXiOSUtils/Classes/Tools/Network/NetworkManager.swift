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

var requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<APIManager>.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = NetworkConfig.requestTimeOut
        done(.success(request))
    } catch {
        print("错误信息:\(error)")
        return
    }
}

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
            //        print(progress)
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
            //       print(resultProgress)
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
        print("请求url详细信息")
        requestParam.printInfo()

        if requestParam.timeOut != NetworkConfig.requestTimeOut {
            requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<APIManager>.RequestResultClosure) in
                do {
                    var request = try endpoint.urlRequest()
                    request.timeoutInterval = requestParam.timeOut
                    done(.success(request))
                } catch {
                    print("错误信息:\(error)")
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
                print(response.statusCode)
                print(response.data.description)
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
        var code:Int = -1
        var description = ""
        if let error = moyaError  {
            print("HTTP请求状态码：\(String(describing: error.response?.statusCode))")
            print("错误原因：\(error.errorDescription ?? "")")
            print(error.errorCode)
            print(error.failureReason as Any)
            print(error.localizedDescription)
            switch error {
            case .imageMapping(let response):
                print(response)
            case .jsonMapping(let response):
                print(response)
            case .stringMapping(let response):
                print(response)
            case .objectMapping(let error, let response):
                print(error)
                print(response)
            case .encodableMapping(let error):
                print(error)
            case .statusCode(let response):
                print(response)
            case .underlying(let error, let response): //没有网络时 、 服务器不存在
                print(error.localizedDescription)
                print(response as Any)
            case .requestMapping(let str):
                print(str)
            case .parameterEncoding(let error):
                print(error)
            }
        } else {

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
    public var statusCode:Int
    /// 错误描述
    public var description:String

    public init(statusCode: Int, description: String) {
        self.statusCode = statusCode
        self.description = description
    }
}
