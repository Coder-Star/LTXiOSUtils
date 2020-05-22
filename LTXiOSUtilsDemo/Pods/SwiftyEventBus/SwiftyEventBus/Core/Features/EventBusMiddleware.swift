//
//  EventBusMiddleware.swift
//  SwiftyEventBus
//
//  Created by Maru on 2018/7/31.
//

import Foundation

/// The advance feature for eventbus
///
/// - safety: safety event that threw error when there is no subscriber
/// - sticky: sticky event that receive previous message when subscribe
enum EventBusFeature: UInt32 {
    case safety = 0x0001
    case sticky = 0x0002

    var isDangerFeature: Bool {
        let range: [EventBusFeature] = [.safety]
        return range.contains(self)
    }
}

class EventBusMiddleWare {

    init(host: EventBus, feautre: EventBusFeature) {
        self.host = host
        self.featureVal = feautre.rawValue
    }

    init(host: EventBus, featureVal: UInt32) {
        self.host = host
        self.featureVal = featureVal
    }

    static func build(host: EventBus, feautre: EventBusFeature) -> EventBusMiddleWare {
        return feautre.isDangerFeature ? EventBusDangerMiddleWare(host: host, feautre: feautre) : EventBusPureMiddleWare(host: host, feautre: feautre)
    }

    let host: EventBus
    
    var featureVal: UInt32

    /// Whether this middleware support specify feature
    ///
    /// - Parameter feature: specify feature
    /// - Returns: A Boolean value indicate support this feautre or not
    func support(_ feature: EventBusFeature) -> Bool {
        return (featureVal & feature.rawValue) > 0
    }

    func compose(by feature: EventBusFeature) -> EventBusMiddleWare {
        fatalError("this method should been override by subclass.")
    }

    func performPost<T>(with queue: Set<EventSubscriber<T>>, cargo: T) {
        /// the priority more largger, the time receive message more earlier.
        let sortedQueue = queue.sorted { (left, right) -> Bool in
            switch (left.priority, right.priority) {
            case (.value(let leftValue), .value(let rightValue)):
                return leftValue < rightValue
            }
        }
        for action in sortedQueue {
            let excuter = action.mode.excuter
            excuter.run(with: cargo, eventHandler: action.eventHandler)
        }
    }
}

class EventBusPureMiddleWare: EventBusMiddleWare {

    override func compose(by feature: EventBusFeature) -> EventBusMiddleWare {
        guard feature.isDangerFeature else {
            return EventBusPureMiddleWare(host: host, featureVal: featureVal | feature.rawValue)
        }
        return EventBusDangerMiddleWare(host: host, featureVal: featureVal | feature.rawValue)
    }
}

class EventBusDangerMiddleWare: EventBusMiddleWare {

    override func compose(by feature: EventBusFeature) -> EventBusMiddleWare {
        return EventBusDangerMiddleWare(host: host, featureVal: featureVal | feature.rawValue)
    }
}
