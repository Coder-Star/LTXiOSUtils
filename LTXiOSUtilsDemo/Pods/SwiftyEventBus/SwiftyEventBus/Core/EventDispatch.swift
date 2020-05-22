//
//  EventDispatch.swift
//  SwiftyEventBus
//
//  Created by Maru on 2018/5/8.
//

import Foundation
import Dispatch

/// The subscribe model when code excuting
///
/// - same: dispatch block in same queue when post and subscribe
/// - main: dispatch block in main queue only when subscribe
public enum DispatchMode {
    case same
    case main
}

extension DispatchMode {

    /// The dispatch excutor for specify model
    var excuter: EventDispatchable {
        switch self {
        case .same:
            return SyncEventDispatch()
        case .main:
            return MainEventDispatch()
        }
    }
}

protocol EventDispatchable {
    var mode: DispatchMode { get }
    func run<T>(with event: T, eventHandler: @escaping (T) -> Void)
}

struct SyncEventDispatch: EventDispatchable {

    var mode: DispatchMode {
        return .same
    }

    func run<T>(with event: T, eventHandler: @escaping (T) -> Void) {
        eventHandler(event)
    }
}

struct MainEventDispatch: EventDispatchable {

    var mode: DispatchMode {
        return .main
    }

    func run<T>(with event: T, eventHandler: @escaping (T) -> Void) {
        guard !DispatchQueue.isMain else {
            eventHandler(event)
            return
        }
        DispatchQueue.main.async {
            eventHandler(event)
        }
    }
}

extension DispatchQueue {

    static var mainToken: DispatchSpecificKey<()> = {
        let token = DispatchSpecificKey<()>()
        DispatchQueue.main.setSpecific(key: token, value: ())
        return token
    }()

    static var isMain: Bool {
        return DispatchQueue.getSpecific(key: mainToken) != nil
    }
}
