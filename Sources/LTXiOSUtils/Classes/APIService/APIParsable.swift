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

// MARK: - APIDefaultJSONParsable

public protocol APIDefaultJSONParsable: APIJSONParsable & Decodable {
    static var jsonDecoder: JSONDecoder { get }
}

extension APIDefaultJSONParsable {
    public static func parse(data: Data) throws -> Self {
        do {
            let model = try JSONDecoder().decode(self, from: data)
            return model
        } catch {
            throw APIResponseError.invalidParseResponse(error)
        }
    }

    public static var jsonDecoder: JSONDecoder {
        return JSONDecoder()
    }
}

// MARK: - 默认实现

extension String: APIParsable {}

extension String: APIJSONParsable {}

extension String: APIDefaultJSONParsable {}

extension Array: APIParsable where Array.Element: APIDefaultJSONParsable {}

extension Array: APIJSONParsable where Element: APIDefaultJSONParsable {}

extension Array: APIDefaultJSONParsable where Array.Element: APIDefaultJSONParsable {}
