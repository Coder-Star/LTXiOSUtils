//
//  APIParsable.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/4.
//

import Foundation

/// 数据解析协议
public protocol APIParsable {
    static func parse(data: Data) -> APIResult<Self>
}

extension Data: APIParsable {
    public static func parse(data: Data) -> APIResult<Self> {
        return .success(data)
    }
}

/// 当Mode实现了Decodable时，为其自动提供实现
extension APIParsable where Self: Decodable {
    public static func parse(data: Data) -> APIResult<Self> {
        do {
            let model = try JSONDecoder().decode(self, from: data)
            return .success(model)
        } catch {
            return .failure(.parseError(error))
        }
    }
}

/// 为数组自动实现
extension Array: APIParsable where Array.Element: APIParsable & Decodable {}

// extension APIParsable where Self: SwiftProtobuf.Message {
//    public static func parse(data: Data) -> APIResult<Self> {
//        do {
//            let model = try self.init(serializedData: data)
//            return .success(model)
//        } catch {
//            return .failure(error)
//        }
//    }
// }
