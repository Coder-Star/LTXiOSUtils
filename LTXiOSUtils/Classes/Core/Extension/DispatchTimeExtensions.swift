//
//  DispatchTimeExtensions.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/9/12.
//

import Foundation


// MARK: - DispatchTime扩展，构造函数

extension DispatchTime: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }

    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1_000))
    }
}
