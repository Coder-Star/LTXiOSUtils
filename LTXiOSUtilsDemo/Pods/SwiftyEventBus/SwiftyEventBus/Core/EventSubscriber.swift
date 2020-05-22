//
//  EventSubscriber.swift
//  SwiftyEventBus
//
//  Created by Maru on 2018/5/1.
//

import Foundation

public class EventSubscriber<T>: NSObject {

    let eventHandler: (T) -> Void

    let mode: DispatchMode
    let priority: EventBusPriority
    
    init(mode: DispatchMode, priority: EventBusPriority = .default, eventHandler: @escaping (T) -> Void) {
        self.mode = mode
        self.priority = priority
        self.eventHandler = eventHandler
    }
}
