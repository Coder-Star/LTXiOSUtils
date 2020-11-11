//
//  ArrayExtensions.swift
//  LTXiOSUtils
//  Array扩展
//  Created by 李天星 on 2020/1/8.
//

import Foundation

extension Array: TxExtensionWrapperCompatibleValue {}

extension TxExtensionWrapper where Base: Sequence {

    /// 数组去重
    /// - Parameter repeated: 去重标准
    public func removeDuplicate<E: Equatable>(_ repeated: (Base.Iterator.Element) -> E) -> [Base.Iterator.Element] {
        var result = [Base.Iterator.Element]()
        self.base.forEach { item in
            let key = repeated(item)
            let keys = result.compactMap { repeated($0) }
            guard !keys.contains(key) else {
                return
            }
            result.append(item)
        }
        return result
    }
}
