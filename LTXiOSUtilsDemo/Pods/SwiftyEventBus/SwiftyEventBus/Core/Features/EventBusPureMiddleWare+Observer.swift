//
//  EventBusPureMiddleWare+Observer.swift
//  SwiftyEventBus
//
//  Created by Maru on 2018/8/1.
//  Copyright © 2018 Alloc. All rights reserved.
//

import Foundation

extension EventBusMiddleWare: EventBusObservable {

    public func register<T>(on mode: DispatchMode = .same, priority: EventBusPriority = .`default`, messageEvent: @escaping (T) -> Void) -> EventSubscription<T> {
        let identifier = EventID(T.self)
        let subscriber = EventSubscriber(mode: mode, priority: priority, eventHandler: messageEvent)
        let subscription = EventSubscription(entity: subscriber, eventBus: host)
        if (support(.sticky)) {
            if let previousCargo: T = host.replayBuff.dequeue() {
                messageEvent(previousCargo)
            }
        }
        if var queue4T = host.observers[identifier] as? Set<EventSubscriber<T>> {
            queue4T.insert(subscriber)
            host.observers[identifier] = queue4T
        } else {
            host.observers[identifier] = Set<EventSubscriber<T>>(arrayLiteral: subscriber)
        }
        return subscription
    }
}
