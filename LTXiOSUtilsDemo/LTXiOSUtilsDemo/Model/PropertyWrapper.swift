//
//  PropertyWrapper.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2022/3/2.
//

import Foundation

///
@propertyWrapper
public struct CodableToString: Codable {
    public var wrappedValue: String?

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        var string: String?
        do {
            string = try container.decode(String.self)
        } catch {
            do {
                string = String(try container.decode(Int.self))
            } catch {
                do {
                    string = String(try container.decode(Double.self))
                } catch {
                    // 如果不想要 String? 可以在此处给 string 赋值  = “”
                    string = nil
                }
            }
        }
        wrappedValue = string
    }
}
