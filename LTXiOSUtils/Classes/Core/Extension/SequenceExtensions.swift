//
//  ArrayExtensions.swift
//  LTXiOSUtils
//  Array扩展
//  Created by 李天星 on 2020/1/8.
//

import Foundation

extension Array: TxExtensionWrapperCompatibleValue {}

extension TxExtensionWrapper where Base: Sequence {

    /// 数组去重,排序后数据保持顺序
    /// - Parameter repeated: 去重标准
    public func removeDuplicate<E: Equatable>(_ repeated: (Base.Iterator.Element) -> E) -> [Base.Iterator.Element] {
        var result = [Base.Iterator.Element]()
        base.forEach {
            let key = repeated($0)
            let keys = result.compactMap { repeated($0) }
            guard !keys.contains(key) else {
                return
            }
            result.append($0)
        }
        return result
    }

    /// keyPath的形式对数组排序
    /// - Parameter keyPath: keyPath
    /// - Returns: 排序后的数组
    public func sorted<T: Comparable>(by keyPath: KeyPath<Base.Iterator.Element, T>) -> [Base.Iterator.Element] {
        return base.sorted {
            return $0[keyPath: keyPath] < $1[keyPath: keyPath]
        }
    }
}
