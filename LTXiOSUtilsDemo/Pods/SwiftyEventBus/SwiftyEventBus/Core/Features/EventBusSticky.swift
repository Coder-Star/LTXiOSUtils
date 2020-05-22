//
//  EventBusSticky.swift
//  SwiftyEventBus
//
//  Created by Maru on 2018/7/31.
//

import Foundation

typealias EventBusMiddle = EventBusPostable & EventBusObservable

protocol EventBusSticky {
    var stick: EventBusMiddle { get }
}

extension EventBus: EventBusSticky {

    var stick: EventBusMiddle {
        return EventBusPureMiddleWare(host: self, feautre: .sticky)
    }
}

extension EventBusMiddleWare: EventBusSticky {

    var stick: EventBusMiddle {
        return EventBusPureMiddleWare(host: host, feautre: .sticky)
    }
}
