//
//  EventBusSafety.swift
//  SwiftyEventBus
//
//  Created by Maru on 2018/7/31.
//  Copyright © 2018 souche. All rights reserved.
//

import Foundation

public protocol EventBusSafety {
    var safe: EventBusSafePostable { get }
}

extension EventBus: EventBusSafety {

    public var safe: EventBusSafePostable {
        return EventBusDangerMiddleWare(host: self, feautre: .safety)
    }
}

extension EventBusMiddleWare: EventBusSafety {

    public var safe: EventBusSafePostable {
        return EventBusDangerMiddleWare(host: host, feautre: .safety)
    }
}
