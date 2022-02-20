//
//  NotificationToken.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/7/27.
//

import Foundation

final public class NotificationToken: NSObject {
    let notificationCenter: NotificationCenter
    let token: Any

    init(notificationCenter: NotificationCenter = .default, token: Any) {
        self.notificationCenter = notificationCenter
        self.token = token
    }

    deinit {
        notificationCenter.removeObserver(token)
    }
}

extension NotificationCenter {
    /// 添加观察
    /// 使用该方式无需手动removeObserver， 但需要将返回的实例保存到属性上去
    /// - Parameters:
    ///   - name: name
    ///   - obj: obj
    ///   - queue: queue
    ///   - block: block
    /// - Returns: NotificationToken
    public func observe(name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> NotificationToken {
        let token = addObserver(forName: name, object: obj, queue: queue, using: block)
        return NotificationToken(notificationCenter: self, token: token)
    }
}
