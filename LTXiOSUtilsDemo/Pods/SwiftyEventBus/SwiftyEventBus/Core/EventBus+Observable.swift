//
//  EventBus+Observable.swift
//  SwiftyEventBus
//
//  Created by Maru on 2018/4/30.
//

import Foundation

public protocol EventBusObservable {

    /// Register a message event for specify DataStruct
    ///
    /// - Parameters:
    ///   - mode: The dispatch model for subscribe
    ///   - priority: a closure that use `T` as only param
    ///   - messageEvent: a closure that use `T` as only param
    /// - Returns: A instance of `EventSubscription`, that hold the subscriber
    func register<T>(on mode: DispatchMode,
                     priority: EventBusPriority,
                     messageEvent: @escaping (T) -> Void) -> EventSubscription<T>
}
