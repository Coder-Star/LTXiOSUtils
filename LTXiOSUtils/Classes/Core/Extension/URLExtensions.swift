//
//  URLExtensions.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2020/9/9.
//

import Foundation

extension TxExtensionWrapper where Base == URL {
    /// 获取URL的参数
    public var parametersFromQueryString: [String: String]? {
        guard let components = URLComponents(url: self.base, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { result, item in
            result[item.name] = item.value
        }
    }
}
