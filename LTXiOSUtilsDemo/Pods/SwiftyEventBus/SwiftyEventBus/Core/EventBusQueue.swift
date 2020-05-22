//
//  EventBusQueue.swift
//  SwiftyEventBus
//
//  Created by Maru on 2018/8/1.
//  Copyright © 2018 Alloc. All rights reserved.
//

import Foundation

class EventBusBuffQueue {

    var map = [String: Any?]()

    func enqueue<T>(_ cargo: T) {
        map[EventID(T.self)] = cargo
    }

    func dequeue<T>() -> T? {
        return map[EventID(T.self)] as? T
    }
}
