//
//  UserDefaultWrapper.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/10/31.
//

import Foundation

/* Example

 enum UserDefaultsConfig {
     @UserDefaultsWrapper("hadShownGuideView", defaultValue: false)
     static var hadShownGuideView: Bool
 }

 var observation: UserDefaultsObservation?

 observation = UserDefaultsConfig.$hadShownGuideView.observe { _, _ in }

 UserDefaultsConfig.hadShownGuideView = true
 let hadShownGuideView = UserDefaultsConfig.hadShownGuideView

 **/

// MARK: - 定义可以被UserDefaults存储的类型

public protocol UserDefaultsStoreValue {}

extension Data: UserDefaultsStoreValue {}
extension String: UserDefaultsStoreValue {}
extension Date: UserDefaultsStoreValue {}
extension Bool: UserDefaultsStoreValue {}
extension Int: UserDefaultsStoreValue {}
extension Double: UserDefaultsStoreValue {}
extension Float: UserDefaultsStoreValue {}
extension Array: UserDefaultsStoreValue where Element: UserDefaultsStoreValue {}
extension Dictionary: UserDefaultsStoreValue where Key == String, Value: UserDefaultsStoreValue {}
extension Optional: UserDefaultsStoreValue {}

@propertyWrapper
public struct UserDefaultsWrapper<T: UserDefaultsStoreValue> {
    let key: String
    let defaultValue: T
    let userDefaults: UserDefaults

    /// 构造函数
    /// - Parameters:
    ///   - key: 存储key值
    ///   - defaultValue: 当存储值不存在时返回的默认值
    public init(_ key: String, defaultValue: T, userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    /// wrappedValue是@propertyWrapper必须需要实现的属性
    /// 当操作我们要包裹的属性时，其具体的set、get方法实际上走的都是wrappedValue的get、set方法
    public var wrappedValue: T {
        get {
            return userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            userDefaults.setValue(newValue, forKey: key)
        }
    }

    /// 使可以通过 $ 的形式访问到 UserDefaultsWrapper，继而可以访问observe方法
    public var projectedValue: UserDefaultsWrapper<T> { return self }

    public func observe(change: @escaping (T?, T?) -> Void) -> UserDefaultsObservation {
        return UserDefaultsObservation(key: key, userDefaults: userDefaults) { old, new in
            change(old as? T, new as? T)
        }
    }
}

/// 观察UserDefaults变化
public class UserDefaultsObservation: NSObject {
    let key: String
    let userDefaults: UserDefaults

    private var onChange: (Any, Any) -> Void

    init(key: String, userDefaults: UserDefaults, onChange: @escaping (Any, Any) -> Void) {
        self.onChange = onChange
        self.key = key
        self.userDefaults = userDefaults
        super.init()
        self.userDefaults.addObserver(self, forKeyPath: key, options: [.old, .new], context: nil)
    }

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change, object != nil, keyPath == key else { return }
        onChange(change[.oldKey] as Any, change[.newKey] as Any)
    }

    deinit {
        userDefaults.removeObserver(self, forKeyPath: key, context: nil)
    }
}
