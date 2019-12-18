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

var provider = MoyaProvider<APIManager>(requestClosure: requestTimeoutClosure, plugins: [LoadingPlugin(), AuthPlugin()])

/// 网络请求工具类
public class NetworkManager {

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
        }, failure: { error in
            self.errorManage(error: error)
        }
        )
    }

    /// 网络请求
    ///
    /// - Parameters:
    ///   - requestParam: 请求参数
    ///   - progress: 进度回调
    ///   - success: 成功回调
    public class func sendRequest(requestParam: RequestParam, progress:@escaping(_ progressResponse: ProgressResponse) -> Void, success:@escaping(_ data: JSON) -> Void) {
        sendRequest(requestParam: requestParam, progress: { resultProgress in
            progress(resultProgress)
        }, success: { data in
            success(data)
        }, failure: { error in
            self.errorManage(error: error)
        }
        )
    }

    /// 网络请求
    ///
    /// - Parameters:
    ///   - requestParam: 请求参数
    ///   - success: 成功回调
    ///   - failure: 失败回调
    public class func sendRequest(requestParam: RequestParam, success:@escaping(_ data: JSON) -> Void, failure:@escaping(_ error: MoyaError) -> Void) {
        sendRequest(requestParam: requestParam, progress: { _ in
            //       print(resultProgress)
        }, success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        }
        )
    }

    /// 基本请求
    public class func sendRequest(requestParam: RequestParam, progress: @escaping(_ progressResponse: ProgressResponse) -> Void, success: @escaping(_ data: JSON) -> Void, failure: @escaping(_ error: MoyaError) -> Void) {
        print("请求url详细信息：\(JSON(requestParam))")
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
            //        print(resultProgress.completed)
            progress(resultProgress)
        }, completion: { result in
            switch result {
            case let .success(response):
                //  let statusCode = response.statusCode
                let data = JSON(response.data)
                success(data)
            case let .failure(error):
                //            print(error)
                failure(error)
            }
        }
        )
    }

    /// 错误处理
    class func errorManage(error: MoyaError) {
        print("错误原因：\(error.errorDescription ?? "")")
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
        case .underlying(let error, let response): //没有网络时 或者 请求超时
            print(error.localizedDescription)
            print(response as Any)
        case .requestMapping(let str):
            print(str)
        case .parameterEncoding(let error):
            print(error)
        }
    }

    // MARK: - 取消所有请求
    /// 去掉所有网络请求
    public class func cancelAllRequest() {
        provider.manager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
}
