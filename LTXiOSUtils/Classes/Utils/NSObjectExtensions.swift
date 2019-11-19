//
//  NSObjectExtensions.swift
//  LTXiOSUtils
//  NSObject扩展
//  Created by 李天星 on 2019/11/18.
//

import Foundation

extension NSObject {

    /// className
    var className: String {
        let name = type(of: self).description()
        if name.contains(".") {
            return name.components(separatedBy: ".")[1]
        } else {
            return name
        }
    }
}

// MARK: - 闭包链式调用
extension NSObject {

    /// 存储key值
    private struct NotificationAction {
        static var key: Void?
    }

    /// 闭包
    public typealias NotificationClosures = (Notification) -> Void

    private var notificationClosuresDict: [NSNotification.Name: NotificationClosures]? {
        get {
            return objc_getAssociatedObject(self, &NotificationAction.key) as? [NSNotification.Name: NotificationClosures]
        }
        set {
            objc_setAssociatedObject(self, &NotificationAction.key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    /// 发出通知
    public func postNotification(_ name: String, userInfo: [AnyHashable: Any]?) {
        NotificationCenter.default.post(name: NSNotification.Name(name), object: self, userInfo: userInfo)
    }

    /// 通知监听
    public func observerNotification(_ name: String, action: @escaping NotificationClosures) {
        if var dict = notificationClosuresDict {
            guard dict[NSNotification.Name(name)] == nil else {
                return
            }
            dict.updateValue(action, forKey: NSNotification.Name(name))
            self.notificationClosuresDict = dict
        } else {
            self.notificationClosuresDict = [NSNotification.Name(name): action]
        }
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction), name: NSNotification.Name(name), object: nil)
    }

    /// 移除监听
    public func removeNotification(_ name: String) {
        NotificationCenter.default.removeObserver(self)
        notificationClosuresDict?.removeValue(forKey: NSNotification.Name(name))
    }

    @objc func notificationAction(notify: Notification) {
        if let notificationClosures = notificationClosuresDict, let closures = notificationClosures[notify.name] {
            closures(notify)
        }
    }
}
