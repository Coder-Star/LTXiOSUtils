//
//  UserDefaultsProtocol.swift
//  LTXiOSUtils
//  UserDefaults协议使枚举继承其时自动获得本地存储能力
//  Created by CoderStar on 2020/1/8.
//

import Foundation

// MARK: - 示例Demo

// enum UserInfoEnum: String {
//    case name
// }
//
// extension UserInfoEnum: UserDefaultsProtocol {
//    var key: String {
//        return self.rawValue
//    }
// }
//
// UserInfoEnum.name.save(int: 5)
// UserInfoEnum.name.int

/// UserDefaults存储协议，建议用枚举去实现该协议
public protocol UserDefaultsProtocol {
    // MARK: - 配置

    /// 存储key
    var key: String { get }

    /// 存储实例
    /// 默认为 UserDefaults.standard
    var userDefaults: UserDefaults { get }

    // MARK: - 取值

    /// 获取值
    var object: Any? { get }

    /// 获取url
    var url: URL? { get }

    /// 获取字符串值
    var string: String? { get }
    /// 获取字符串值,默认值为空
    var stringValue: String { get }

    /// 获取字典值
    var dictionary: [String: Any]? { get }
    /// 获取字典值,默认值为空
    var dictionaryValue: [String: Any] { get }

    /// 获取列表值
    var array: [Any]? { get }
    /// 获取列表值,默认值为空
    var arrayValue: [Any] { get }

    /// 获取字符串列表值
    var stringArray: [String]? { get }
    /// 获取字符串列表值,默认值为空
    var stringArrayValue: [String] { get }

    /// 获取Data值
    var data: Data? { get }
    /// 获取Data值,默认值为空
    var dataValue: Data { get }

    /// 获取Bool值
    var bool: Bool? { get }
    /// 获取Bool值，默认值为false
    var boolValue: Bool { get }

    /// 获取int值
    var int: Int? { get }
    /// 获取int值,默认值为0
    var intValue: Int { get }

    /// 获取float值
    var float: Float? { get }
    /// 获取float值,默认值为0
    var floatValue: Float { get }

    /// 获取double值
    var double: Double? { get }
    /// 获取double值,默认值为0
    var doubleValue: Double { get }

    // MARK: - 存值

    /// 存储
    /// - Parameter object: 存储object型
    func save(object: Any?)

    /// 存储
    /// - Parameter int: 存储int型
    func save(int: Int)

    /// 存储
    /// - Parameter float: 存储float型
    func save(float: Float)

    /// 存储
    /// - Parameter double: 存储double型
    func save(double: Double)

    /// 存储
    /// - Parameter bool: 存储bool型
    func save(bool: Bool)

    /// 存储
    /// - Parameter url: 存储url型
    func save(url: URL?)

    /// 移除
    func remove()
}

// MARK: - 协议默认实现

extension UserDefaultsProtocol {
    /// 默认userDefaults对象，默认为UserDefaults.standard
    public var userDefaults: UserDefaults {
        return UserDefaults.standard
    }

    /// 获取object
    public var object: Any? {
        return userDefaults.object(forKey: key)
    }

    /// 获取url
    public var url: URL? {
        return userDefaults.url(forKey: key)
    }

    /// 获取字符串值
    public var string: String? {
        return userDefaults.string(forKey: key)
    }

    /// 获取字符串值,默认值为空
    public var stringValue: String {
        return userDefaults.string(forKey: key) ?? ""
    }

    /// 获取字典值
    public var dictionary: [String: Any]? {
        return userDefaults.dictionary(forKey: key)
    }

    /// 获取字典值,默认值为空
    public var dictionaryValue: [String: Any] {
        return userDefaults.dictionary(forKey: key) ?? [String: Any]()
    }

    /// 获取列表值
    public var array: [Any]? {
        return userDefaults.array(forKey: key)
    }

    /// 获取列表值,默认值为空
    public var arrayValue: [Any] {
        return userDefaults.array(forKey: key) ?? [Any]()
    }

    /// 获取字符串列表值
    public var stringArray: [String]? {
        return userDefaults.stringArray(forKey: key)
    }

    /// 获取字符串列表值,默认值为空
    public var stringArrayValue: [String] {
        return userDefaults.stringArray(forKey: key) ?? [String]()
    }

    /// 获取Data值
    public var data: Data? {
        return userDefaults.data(forKey: key)
    }

    /// 获取Data值,默认值为空
    public var dataValue: Data {
        return userDefaults.data(forKey: key) ?? Data()
    }

    /// 获取Bool值
    public var bool: Bool? {
        return userDefaults.object(forKey: key) as? Bool
    }

    /// 获取Bool值,默认值false
    public var boolValue: Bool {
        return userDefaults.bool(forKey: key)
    }

    /// 获取int值
    public var int: Int? {
        return userDefaults.object(forKey: key) as? Int
    }

    /// 获取int值，默认值0
    public var intValue: Int {
        return userDefaults.integer(forKey: key)
    }

    /// 获取float值
    public var float: Float? {
        return userDefaults.object(forKey: key) as? Float
    }

    /// 获取float值，默认值0
    public var floatValue: Float {
        return userDefaults.float(forKey: key)
    }

    /// 获取float值
    public var double: Double? {
        return userDefaults.object(forKey: key) as? Double
    }

    /// 获取double值，默认值0
    public var doubleValue: Double {
        return userDefaults.double(forKey: key)
    }

    /// 存储
    /// - Parameter value: 存储object
    public func save(object: Any?) {
        userDefaults.set(object, forKey: key)
    }

    /// 存储
    /// - Parameter int: 存储int型
    public func save(int: Int) {
        userDefaults.set(int, forKey: key)
    }

    /// 存储
    /// - Parameter float: 存储float型
    public func save(float: Float) {
        userDefaults.set(float, forKey: key)
    }

    /// 存储
    /// - Parameter double: 存储double型
    public func save(double: Double) {
        userDefaults.set(double, forKey: key)
    }

    /// 存储
    /// - Parameter bool: 存储bool型
    public func save(bool: Bool) {
        userDefaults.set(bool, forKey: key)
    }

    /// 存储
    /// - Parameter url: 存储url型
    public func save(url: URL?) {
        userDefaults.set(url, forKey: key)
    }

    /// 移除
    public func remove() {
        userDefaults.removeObject(forKey: key)
    }
}
