//
//  DoubleExtensions.swift
//  LTXiOSUtils
//  Double扩展
//  Created by 李天星 on 2020/3/20.
//

import Foundation

public extension Double {

    /// 去除浮点数后面多余的0
    var removeSuffixZero: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }

}
