//
//  APIParsable.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/4.
//

import Foundation

// MARK: - APIParsable

public protocol APIParsable {
    static func parse(data: Data) throws -> Self
}

extension Data: APIParsable {
    public static func parse(data: Data) throws -> Self {
        return data
    }
}

// MARK: - APIJSONParsable

public protocol APIJSONParsable: APIParsable {}

extension APIJSONParsable where Self: Decodable {
    public static func parse(data: Data) throws -> Self {
        do {
            let model = try JSONDecoder().decode(self, from: data)
            return model
        } catch {
            throw APIResponseError.invalidParseResponse(error)
        }
    }
}

public typealias APIDefaultJSONParsable = APIJSONParsable & Decodable

// MARK: - 默认实现

extension String: APIParsable {}

extension String: APIJSONParsable {}

extension Array: APIParsable where Array.Element: APIDefaultJSONParsable {}

extension Array: APIJSONParsable where Element: APIDefaultJSONParsable {}
