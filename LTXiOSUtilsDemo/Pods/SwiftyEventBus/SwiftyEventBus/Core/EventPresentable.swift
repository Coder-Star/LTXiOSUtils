//
//  EventPresentable.swift
//  SwiftyEventBus
//
//  Created by Maru on 2018/5/1.
//

import Foundation

/// Get unique string for `T` type
///
/// - Parameter type: type `T`
/// - Returns: a string instance that present `T`
func EventID<T>(_ type: T.Type) -> String {
    return String(reflecting: type)
}
