//
//  ChainGrammar.swift
//  LTXiOSUtils
//  链式语法
//  Created by CoderStar on 2020/2/20.
//

import Foundation

// MARK: - Then

/// 接口
public protocol Then {}

extension Then where Self: Any {
    /// 值类型数据初始化属性
    ///
    ///     let frame = CGRect().with {
    ///       $0.origin.x = 10
    ///       $0.size.width = 100
    ///     }
    public func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }

    /// 初始化动作，与初始化属性不同在于此没有返回值
    ///
    ///     UserDefaults.standard.do {
    ///       $0.set("devxoul", forKey: "username")
    ///       $0.set("devxoul@gmail.com", forKey: "email")
    ///       $0.synchronize()
    ///     }
    public func `do`(_ block: (Self) throws -> Void) rethrows {
        try block(self)
    }
}

extension Then where Self: AnyObject {
    /// 引用类型数据初始化属性
    ///
    ///     let label = UILabel().then {
    ///       $0.textAlignment = .center
    ///       $0.textColor = UIColor.black
    ///       $0.text = "Hello, World!"
    ///     }
    public func then(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

extension NSObject: Then {}
extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
extension CGVector: Then {}
extension Array: Then {}
extension Dictionary: Then {}
extension Set: Then {}
extension UIEdgeInsets: Then {}
extension UIOffset: Then {}
extension UIRectEdge: Then {}



/// dynamicMemberLookup实现链式语法
///
/// - Note: 使用方式
/// ```
///     Setter(subject: UIView())
///     .frame(CGRect(x: 0, y: 0, width: 100, height: 100))
///     .backgroundColor(.white)
///     .alpha(0.5)
///     .subject
///  ```
@dynamicMemberLookup
public struct Setter<Subject> {
    let subject: Subject

    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Subject, Value>) -> ((Value) -> Setter<Subject>) {
        // 获取到真正的对象
        var subject = self.subject
        return { value in
            // 把 value 指派给 subject
            subject[keyPath: keyPath] = value
            // 回传的类型是 Setter 而不是 Subject
            // 因为使用Setter来链式，而不是 Subject 本身
            return Setter(subject: subject)
        }
    }
}
