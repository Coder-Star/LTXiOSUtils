//
//  ArrayExtensions.swift
//  LTXiOSUtils
//  Array扩展
//  Created by 李天星 on 2020/1/8.
//

import Foundation

public extension Array {

    /// 数组去重
    /// - Parameter repeated: 去重标准
    func removeDuplicate<E: Equatable>(_ repeated: (Element) -> E) -> [Element] {
        var result = [Element]()
        self.forEach { item in
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
