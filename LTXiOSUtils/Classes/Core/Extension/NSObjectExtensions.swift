//
//  NSObjectExtensions.swift
//  LTXiOSUtils
//  NSObject扩展
//  Created by CoderStar on 2019/11/18.
//

import Foundation

extension NSObject: TxExtensionWrapperCompatible {}

// MARK: - 基础

extension TxExtensionWrapper where Base: NSObject {
    /// 根据对象获取类名
    public var className: String {
        let name = type(of: base).description()
        if name.contains(".") {
            return name.components(separatedBy: ".")[1]
        } else {
            return name
        }
    }
}

// MARK: - 获取NSObject子类的所有属性值，使用这个需要类是NSObject的子类，且前面加上@objcMembers，否则为空数组

extension TxExtensionWrapper where Base: NSObject {
    /// 获取指定属性的值
    ///
    /// - Parameter property: 属性
    /// - Returns: 属性值
    public func getValueOfProperty(property: String) -> AnyObject? {
        let allPropertys = getAllProperties()
        if allPropertys.contains(property) {
            return base.value(forKey: property) as AnyObject
        } else {
            return nil
        }
    }

    /// 设置指定属性的值
    ///
    /// - Parameters:
    ///   - property: 属性
    ///   - value: 属性新值
    public func setValueOfProperty(property: String, value: AnyObject) {
        let allPropertys = getAllProperties()
        if allPropertys.contains(property) {
            base.setValue(value, forKey: property)
        }
    }

    /// 获取所有属性还有值
    ///
    /// - Returns: 属性以及对应的值
    public func getAllPropertysAndValue() -> [String: Any] {
        var result = [String: Any]()
        for item in getAllProperties() {
            result[item] = getValueOfProperty(property: item)
        }
        return result
    }

    /// 静态方法，获取对象的所有属性名称
    /// 获取对象的所有属性
    /// 注意:必须在获取类的class前添加@objcMembers，不然获取为空数组
    /// - Returns: 属性列表
    public static func getAllProperties(ignoredProperties: [String] = []) -> [String] {
        var count: UInt32 = 0
        let properties = class_copyPropertyList(Base.classForCoder(), &count)
        var propertyNames: [String] = []
        for i in 0 ..< Int(count) {
            let property = properties![i]
            let name = property_getName(property)
            let strName = String(cString: name)
            propertyNames.append(strName)
        }
        free(properties) // 释放内存

        return propertyNames.filter { !ignoredProperties.contains($0) }
    }

    /// 获取对象的所有属性名称
    /// 获取对象的所有属性
    /// 注意:必须在获取类的class前添加 @objcMembers，不然获取为空数组
    /// - Returns: 属性列表
    private func getAllProperties() -> [String] {
        var count: UInt32 = 0
        let properties = class_copyPropertyList(base.classForCoder, &count)
        var propertyNames: [String] = []
        for i in 0 ..< Int(count) {
            let property = properties![i]
            let name = property_getName(property)
            let strName = String(cString: name)
            propertyNames.append(strName)
        }
        free(properties) // 释放内存
        return propertyNames
    }
}

// MARK: - 通知闭包链式调用

extension NSObject {
    /// 存储key值
    private struct NotificationAction {
        static var notificationClosures: Void?
        static var notificationVoidClosures: Void?
    }

    /// 闭包
    public typealias NotificationClosures = (Notification) -> Void
    /// 闭包
    public typealias NotificationVoidClosures = () -> Void

    private var notificationClosuresDict: [NSNotification.Name: NotificationClosures]? {
        get {
            return objc_getAssociatedObject(self, &NotificationAction.notificationClosures) as? [NSNotification.Name: NotificationClosures]
        }
        set {
            objc_setAssociatedObject(self, &NotificationAction.notificationClosures, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    private var notificationVoidClosuresDict: [NSNotification.Name: NotificationVoidClosures]? {
        get {
            return objc_getAssociatedObject(self, &NotificationAction.notificationVoidClosures) as? [NSNotification.Name: NotificationVoidClosures]
        }
        set {
            objc_setAssociatedObject(self, &NotificationAction.notificationVoidClosures, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    /// 发出通知
    /// - Parameters:
    ///   - name: 名称
    ///   - userInfo: 携带信息
    func postNotification(_ name: NSNotification.Name, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: self, userInfo: userInfo)
    }

    /// 通知监听
    /// - Parameters:
    ///   - name: 名称
    ///   - object: 发送对象
    ///   - action: 动作，回调Notification
    public func observerNotification(_ name: NSNotification.Name, object: Any? = nil, action: @escaping NotificationClosures) {
        if var dict = notificationClosuresDict {
            guard dict[name] == nil else {
                return
            }
            dict.updateValue(action, forKey: name)
            notificationClosuresDict = dict
        } else {
            notificationClosuresDict = [name: action]
        }
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction), name: name, object: object)
    }

    /// 通知监听
    /// - Parameters:
    ///   - name: 名称
    ///   - object: 发送对象
    ///   - action: 动作，回调Void
    public func observerNotification(_ name: NSNotification.Name, object: Any? = nil, action: @escaping NotificationVoidClosures) {
        if var dict = notificationVoidClosuresDict {
            guard dict[name] == nil else {
                return
            }
            dict.updateValue(action, forKey: name)
            notificationVoidClosuresDict = dict
        } else {
            notificationVoidClosuresDict = [name: action]
        }
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction), name: name, object: object)
    }

    /// 移除监听
    /// - Parameter name: 名称
    public func removeNotification(_ name: NSNotification.Name, object: Any? = nil) {
        NotificationCenter.default.removeObserver(self, name: name, object: object)
        notificationClosuresDict?.removeValue(forKey: name)
    }

    /// 移除监听
    public func removeNotification() {
        NotificationCenter.default.removeObserver(self)
        notificationClosuresDict?.removeAll()
    }

    @objc
    private func notificationAction(notify: Notification) {
        if let notificationClosures = notificationClosuresDict, let closures = notificationClosures[notify.name] {
            closures(notify)
        } else if let notificationClosures = notificationVoidClosuresDict, let closures = notificationClosures[notify.name] {
            closures()
        }
    }
}
