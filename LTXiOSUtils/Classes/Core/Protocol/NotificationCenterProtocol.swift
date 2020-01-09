//
//  NotificationCenterProtocol.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2020/1/8.
//

import Foundation

//public protocol NotificationCenterProtocol {
//    /// 名称
//    var name: String { get }
//    /// 发送通知
//    /// - Parameters:
//    ///   - object: 发送者对象
//    ///   - userInfo: 携带信息
//    func post(_ object:Any?, userInfo:[AnyHashable:Any]?)
//    func addObserver(withSelector selector: Selector, observer: Any, object: Any?)
//    func remove(_ observer: Any, object:Any?)
//}
//
//public extension NotificationCenterProtocol {
//    func post(_ object:Any?, userInfo:[AnyHashable:Any]?){
//        NotificationCenter.default.post(name: NSNotification.Name(name), object: object, userInfo: userInfo)
//    }
//
//    func remove(_ observer: Any, object:Any? = nil) {
//        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(name), object: object)
//    }
//}

// MARK: - 通知闭包链式调用
//public extension NSObject {
//
//    /// 存储key值
//    private struct NotificationAction {
//        static var key: Void?
//    }
//
//    /// 闭包
//    typealias NotificationClosures = (Notification) -> Void
//
//    private var notificationClosuresDict: [NSNotification.Name: NotificationClosures]? {
//        get {
//            return objc_getAssociatedObject(self, &NotificationAction.key) as? [NSNotification.Name: NotificationClosures]
//        }
//        set {
//            objc_setAssociatedObject(self, &NotificationAction.key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
//        }
//    }
//    /// 发出通知
//    func postNotification(_ name: String, userInfo: [AnyHashable: Any]?) {
//        NotificationCenter.default.post(name: NSNotification.Name(name), object: self, userInfo: userInfo)
//    }
//
//    /// 通知监听
//    func observerNotification(_ name: String, action: @escaping NotificationClosures) {
//        if var dict = notificationClosuresDict {
//            guard dict[NSNotification.Name(name)] == nil else {
//                return
//            }
//            dict.updateValue(action, forKey: NSNotification.Name(name))
//            self.notificationClosuresDict = dict
//        } else {
//            self.notificationClosuresDict = [NSNotification.Name(name): action]
//        }
//        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction), name: NSNotification.Name(name), object: nil)
//    }
//
//    /// 移除监听
//    func removeNotification(_ name: String) {
//        NotificationCenter.default.removeObserver(self)
//        notificationClosuresDict?.removeValue(forKey: NSNotification.Name(name))
//    }
//
//    @objc private func notificationAction(notify: Notification) {
//        if let notificationClosures = notificationClosuresDict, let closures = notificationClosures[notify.name] {
//            closures(notify)
//        }
//    }
//}
