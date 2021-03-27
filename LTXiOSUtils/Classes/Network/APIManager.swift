//
//  APIManager.swift
//  LTXiOSUtils
//  
//  Created by 李天星 on 2019/9/3.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation
import Moya

/// 请求分类
public enum APIManager {
    /// 获取数据
    case getData(requestParam: RequestParam)
    /// 上传文件
    case uploadFile
    /// 下载文件
    case downloadFile
}

/// 请求配置
extension APIManager: CustomizeTargetType {
    public var baseURL: URL {
        switch self {
        case .getData(let requestParam):
            return URL(string: requestParam.baseUrl)!
        default:
            return URL(string: "")!
        }
    }

    /// 请求路径
    public var path: String {
        switch self {
        case .getData(let requestParam):
            return requestParam.path
        default:
            return ""
        }
    }

    /// 请求类型
    public var method: Moya.Method {
        switch self {
        case .getData(let requestParam):
            return requestParam.method
        default:
            return .post
        }
    }

    /// 单元测试数据
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    /// 请求任务事件
    public var task: Task {
        switch self {
        case .getData(let requestParam):
            //上传文件
            guard let fileList = requestParam.fileList else {
                /// 非上传文件
                return .requestParameters(parameters: requestParam.parameters, encoding: requestParam.parameterEncoding)
            }
            var multipartFormDataList = [MultipartFormData]()
            for item in fileList {
                let multipartFormData = MultipartFormData(provider: .data(item.data), name: item.name, fileName: item.name, mimeType: item.type)
                multipartFormDataList.append(multipartFormData)
            }
            let urlParameters = requestParam.parameters
            return .uploadCompositeMultipart(multipartFormDataList, urlParameters:urlParameters)

        default:
            return .requestPlain
        }
    }

    public var headers: [String: String]? {
        return nil
    }

    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
}
