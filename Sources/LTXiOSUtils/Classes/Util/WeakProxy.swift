//
//  WeakProxy.swift
//  LTXiOSUtils
//  用在Timer等场景，防止循环引用
//  Created by CoderStar on 2021/7/27.
//

import Foundation

final public class WeakProxy: NSObject {
    private weak var target: NSObjectProtocol?

    public init(_ target: NSObjectProtocol?) {
        self.target = target
        super.init()
    }

    public class func proxy(with target: NSObjectProtocol?) -> WeakProxy {
        return WeakProxy(target)
    }
}

extension WeakProxy {
    // 消息转发
    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        // 判断是否实现了Selector，如果实现了，就将消息转发给它
        if target?.responds(to: aSelector) == true {
            return target
        } else {
            return super.forwardingTarget(for: aSelector)
        }
    }

    public override func responds(to aSelector: Selector!) -> Bool {
        return target?.responds(to: aSelector) == true
    }

    public override func conforms(to aProtocol: Protocol) -> Bool {
        return target?.conforms(to: aProtocol) == true
    }

    public override func isEqual(_ object: Any?) -> Bool {
        return target?.isEqual(object) == true
    }

    public override var superclass: AnyClass? {
        return target?.superclass
    }

    public override func isKind(of aClass: AnyClass) -> Bool {
        return target?.isKind(of: aClass) == true
    }

    public override func isMember(of aClass: AnyClass) -> Bool {
        return target?.isMember(of: aClass) == true
    }

    public override var description: String {
        return target?.description ?? ""
    }

    public override var debugDescription: String {
        return target?.debugDescription ?? ""
    }
}
