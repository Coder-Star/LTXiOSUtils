//
//  DoubleExtensions.swift
//  LTXiOSUtils
//  Double扩展
//  Created by CoderStar on 2020/3/20.
//

extension Double: TxExtensionWrapperCompatibleValue {}

extension TxExtensionWrapper where Base == Double {
    /// 去除浮点数后面多余的0
    public var removeSuffixZero: String {
        return base.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", base) : String(base)
    }
}
