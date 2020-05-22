//
//  EventBus.swift
//  SwiftyEventBus
//
//  Created by Maru on 2018/4/30.
//

import Foundation

/// Default domain string for `EventBus`
private let defaultDomain = "com.eventbus.swifty.domain.default"

/// The priority of subscriber to revieve message
///
/// - low: low leve priority, value is 1
/// - default: default leve priority, value is 5
/// - high: high leve priority, value is 10
public enum EventBusPriority {

    case value(Int)

    public static var low: EventBusPriority {
        return .value(250)
    }

    public static var `default`: EventBusPriority {
        return .value(500)
    }

    public static var high: EventBusPriority {
        return .value(1000)
    }
}

public class EventBus {

    /// The default common `EventBus` instance
    public static let `default` = EventBus(domain: defaultDomain)

    /// The domain string that identify different `EventBus` instance
    public let domain: String

    /// The Dictionary that contain all `EventSubscriber`
    /// Discuss: we use string of type as key, and a set of `EventSubscriber`
    /// as value. when register or unregister, we just need to modify corresponding
    /// set.
    var observers: [String: Any]

    /// The dictinary that contain the lastest N message event
    /// for support sticky and replay event
    let replayBuff = EventBusBuffQueue()

    /// The middleware that perform post and register actually
    var middleWare: EventBusPureMiddleWare {
        return EventBusPureMiddleWare(host: self, featureVal: 0)
    }

    /// The construction of `EventBus`
    ///
    /// - Parameter domain: The domain string
    public init(domain: String) {
        self.domain = domain
        self.observers = [String: Any]()
    }
}

extension EventBus: EventBusPostable {

    public func post<T>(_ cargo: T) {
        middleWare.post(cargo)
    }
}

extension EventBus: EventBusObservable {

    public func register<T>(on mode: DispatchMode = .same, priority: EventBusPriority = .`default`, messageEvent: @escaping (T) -> Void) -> EventSubscription<T> {
        return middleWare.register(on: mode, priority: priority, messageEvent: messageEvent)
    }
}
