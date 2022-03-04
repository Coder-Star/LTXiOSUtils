//
//  APIParsable.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/4.
//

import Foundation

public protocol APIParsable {
    static func parse(data: Data) -> APIResult<Self>
}

extension Array: APIParsable where Array.Element: APIParsable & Decodable {}

extension APIParsable where Self: Decodable {
    public static func parse(data: Data) -> APIResult<Self> {
        do {
            let model = try JSONDecoder().decode(self, from: data)
            return .success(model)
        } catch {
            return .failure(error)
        }
    }
}

// extension Parsable where Self: SwiftProtobuf.Message {
//    public static func parse(data: Data) -> Result<Self> {
//        do {
//            let model = try self.init(serializedData: data)
//            return .success(model)
//        } catch {
//            return .failure(error)
//        }
//    }
// }
