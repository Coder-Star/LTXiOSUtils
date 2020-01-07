//
//  NSObjectExtensions.swift
//  LTXiOSUtils
//  NSObject扩展
//  Created by 李天星 on 2019/11/18.
//

import Foundation
// MARK: - 基础
public extension NSObject {

    /// 类名
    var className: String {
        let name = type(of: self).description()
        if name.contains(".") {
            return name.components(separatedBy: ".")[1]
        } else {
            return name
        }
    }
}

// MARK: - 通知闭包链式调用
public extension NSObject {

    /// 存储key值
    private struct NotificationAction {
        static var key: Void?
    }

    /// 闭包
    typealias NotificationClosures = (Notification) -> Void

    private var notificationClosuresDict: [NSNotification.Name: NotificationClosures]? {
        get {
            return objc_getAssociatedObject(self, &NotificationAction.key) as? [NSNotification.Name: NotificationClosures]
        }
        set {
            objc_setAssociatedObject(self, &NotificationAction.key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    /// 发出通知
    func postNotification(_ name: String, userInfo: [AnyHashable: Any]?) {
        NotificationCenter.default.post(name: NSNotification.Name(name), object: self, userInfo: userInfo)
    }

    /// 通知监听
    func observerNotification(_ name: String, action: @escaping NotificationClosures) {
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
    func removeNotification(_ name: String) {
        NotificationCenter.default.removeObserver(self)
        notificationClosuresDict?.removeValue(forKey: NSNotification.Name(name))
    }

    @objc private func notificationAction(notify: Notification) {
        if let notificationClosures = notificationClosuresDict, let closures = notificationClosures[notify.name] {
            closures(notify)
        }
    }
}

// MARK: - 获取NSObject子类的所有属性值，使用这个需要类是NSObject的子类，且前面加上@objcMembers，否则为空数组
public extension NSObject {
    /// 获取指定属性的值
    ///
    /// - Parameter property: 属性
    /// - Returns: 属性值
    func getValueOfProperty(property: String) -> AnyObject? {
        let allPropertys = self.getAllPropertys()
        if(allPropertys.contains(property)) {
            return self.value(forKey: property) as AnyObject
        } else {
            return nil
        }
    }

    /// 设置指定属性的值
    ///
    /// - Parameters:
    ///   - property: 属性
    ///   - value: 属性新值
    func setValueOfProperty(property: String, value: AnyObject) {
        let allPropertys = self.getAllPropertys()
        if(allPropertys.contains(property)) {
            self.setValue(value, forKey: property)
        }
    }

    /// 获取所有属性还有值
    ///
    /// - Returns: 属性以及对应的值
    func getAllPropertysAndValue() -> [String: Any] {
        var result = [String: Any]()
        for item in getAllPropertys() {
            result[item] = getValueOfProperty(property: item)
        }
        return result
    }

    /// 静态方法，获取对象的所有属性名称
    /// 获取对象的所有属性
    /// 注意:必须在获取类的class前添加 ，不然获取为空数组
    /// - Returns: 属性列表
    class func getAllPropertys(ignoredProperties: [String] = [String]()) -> [String] {
        var count: UInt32 = 0
        let properties = class_copyPropertyList(self.classForCoder(), &count)
        var propertyNames: [String] = []
        for i in 0..<Int(count) {
            let property = properties![i]
            let name = property_getName(property)
            let strName =  String(cString: name)
            propertyNames.append(strName)
        }
        free(properties) //释放内存

        return propertyNames.filter {!ignoredProperties.contains($0)}
    }

    /// 获取对象的所有属性名称
    /// 获取对象的所有属性
    /// 注意:必须在获取类的class前添加 @objcMembers，不然获取为空数组
    /// - Returns: 属性列表
    private func getAllPropertys() -> [String] {
        var count: UInt32 = 0
        let properties = class_copyPropertyList(self.classForCoder, &count)
        var propertyNames: [String] = []
        for i in 0..<Int(count) {
            let property = properties![i]
            let name = property_getName(property)
            let strName =  String(cString: name)
            propertyNames.append(strName)
        }
        free(properties) //释放内存
        return propertyNames
    }

}
