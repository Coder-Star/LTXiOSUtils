//
//  UserDefaultsProtocol.swift
//  LTXiOSUtils
//  UserDefaults协议使枚举继承其时自动获得本地存储能力
//  Created by 李天星 on 2020/1/8.
//

import Foundation

// MARK: - 示例Demo
//enum UserInfoEnum: String {
//    case name
//}
//
//extension UserInfoEnum: UserDefaultsProtocol {
//    var key: String {
//        return self.rawValue
//    }
//}
//
//UserInfoEnum.name.save(int: 5)
//UserInfoEnum.name.int

/// UserDefaults存储协议，建议用枚举去实现该协议
public protocol UserDefaultsProtocol {
// MARK: - 存储key
    /// 存储key
    var key: String { get }

// MARK: - 存在nil
    /// 获取值
    var object: Any? { get }

    /// 获取url
    var url: URL? { get }

// MARK: - 存在nil，有默认值
    /// 获取字符串值
    var string: String? { get }
    /// 获取字符串值,默认值为空
    var stringValue: String { get }

    /// 获取字典值
    var dictionary: [String:Any]? { get }
    /// 获取字典值,默认值为空
    var dictionaryValue: [String:Any] { get }

    /// 获取列表值
    var array: [Any]? { get }
    /// 获取列表值,默认值为空
    var arrayValue: [Any] { get }

    /// 获取字符串列表值
    var stringArray: [String]? { get }
    /// 获取字符串列表值,默认值为空
    var stringArrayValue: [String] { get }

    /// 获取Data值
    var data: Data? {get}
    /// 获取Data值,默认值为空
    var dataValue: Data {get}

// MARK: - 不存在nil
    /// 获取Bool值,有默认值
    var bool: Bool { get }

    /// 获取int值,有默认值
    var int: Int { get }

    /// 获取float值,有默认值
    var float: Float { get }

    /// 获取double值,有默认值
    var double: Double { get }

// MARK: - 方法
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

// MARK: - 协议方法及计算属性实现
public extension UserDefaultsProtocol {

// MARK: - 存在nil
    /// 获取object
    var object:Any? {
        return UserDefaults.standard.object(forKey: key)
    }

    /// 获取url
    var url:URL? {
        return UserDefaults.standard.url(forKey: key)
    }

// MARK: - 存在nil，有默认值
    /// 获取字符串值
    var string: String? {
        return UserDefaults.standard.string(forKey: key)
    }
    /// 获取字符串值,默认值为空
    var stringValue: String {
        return UserDefaults.standard.string(forKey: key) ?? ""
    }

    /// 获取字典值
    var dictionary: [String:Any]? {
        return UserDefaults.standard.dictionary(forKey: key)
    }
    /// 获取字典值,默认值为空
    var dictionaryValue: [String:Any] {
        return UserDefaults.standard.dictionary(forKey: key) ?? [String:Any]()
    }

    /// 获取列表值
    var array: [Any]? {
        return UserDefaults.standard.array(forKey: key)
    }
    /// 获取列表值,默认值为空
    var arrayValue: [Any] {
        return UserDefaults.standard.array(forKey: key) ?? [Any]()
    }

    /// 获取字符串列表值
    var stringArray: [String]? {
        return UserDefaults.standard.stringArray(forKey: key)
    }
    /// 获取字符串列表值,默认值为空
    var stringArrayValue: [String] {
        return UserDefaults.standard.stringArray(forKey: key) ?? [String]()
    }

    /// 获取Data值
    var data: Data? {
        return UserDefaults.standard.data(forKey: key)
    }
    /// 获取Data值,默认值为空
    var dataValue: Data {
        return UserDefaults.standard.data(forKey: key) ?? Data()
    }

// MARK: - 不存在nil
    /// 获取Bool值
    var bool:Bool {
        return UserDefaults.standard.bool(forKey: key)
    }

    /// 获取Bool值
    var int:Int {
        return UserDefaults.standard.integer(forKey: key)
    }

    /// 获取Bool值
    var float:Float {
        return UserDefaults.standard.float(forKey: key)
    }

    /// 获取Bool值
    var double:Double {
        return UserDefaults.standard.double(forKey: key)
    }

// MARK: - 方法
    /// 存储
    /// - Parameter value: 存储object
    func save(object: Any?) {
        UserDefaults.standard.set(object, forKey: key)
    }

    /// 存储
    /// - Parameter int: 存储int型
    func save(int: Int) {
        UserDefaults.standard.set(int, forKey: key)
    }

    /// 存储
    /// - Parameter float: 存储float型
    func save(float: Float) {
        UserDefaults.standard.set(float, forKey: key)
    }

    /// 存储
    /// - Parameter double: 存储double型
    func save(double: Double) {
        UserDefaults.standard.set(double, forKey: key)
    }

    /// 存储
    /// - Parameter bool: 存储bool型
    func save(bool: Bool) {
        UserDefaults.standard.set(bool, forKey: key)
    }

    /// 存储
    /// - Parameter url: 存储url型
    func save(url: URL?) {
        UserDefaults.standard.set(url, forKey: key)
    }

    /// 移除
    func remove() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
