//
//  Then.swift
//  LTXiOSUtils
//  语法糖，用于属性初始化
//  Created by 李天星 on 2020/2/20.
//

import Foundation

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
