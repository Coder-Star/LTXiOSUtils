//
//  Atomic.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/3/24.
//

import Foundation

/* Example

 struct MyStruct {
     @Atomic var x = 0
 }

 var value = MyStruct()

 /// 写
 value.x = 1

 /// 边读边写
 value.$x.mutate { $0 += 1 }

 **/

/// 因为要实现 `mutate` 的操作，需要使用class结构，struct结构不ok

@propertyWrapper
final public class Atomic<Value> {
    private let queue = DispatchQueue(label: "com.coderstar.atomic")
    private var value: Value

    public init(wrappedValue: Value) {
        value = wrappedValue
    }

    /// 保证分别读写安全
    public var wrappedValue: Value {
        get {
            return queue.sync { value }
        }
        set {
            queue.sync { value = newValue }
        }
    }

    public var projectedValue: Atomic<Value> {
        return self
    }

    /// 保证边读边写安全
    public func mutate(_ mutation: (inout Value) -> Void) {
        return queue.sync {
            mutation(&value)
        }
    }
}
