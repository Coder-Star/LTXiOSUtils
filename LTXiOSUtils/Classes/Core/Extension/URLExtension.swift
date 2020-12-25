//
//  URLExtension.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2020/9/9.
//

import Foundation

extension URL {

    /// 获取URL的参数
    public var parametersFromQueryString: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
        let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { result, item in
            result[item.name] = item.value
        }
    }
}
