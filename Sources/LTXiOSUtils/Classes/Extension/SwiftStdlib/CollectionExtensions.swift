//
//  CollectionExtensions.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/9/14.
//

extension Collection {
    /// 安全取指定索引数据
    ///
    /// - Parameters:
    ///   - safeIndex: 指定索引
    public subscript(safeIndex index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    /// 判断集合非空
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}
