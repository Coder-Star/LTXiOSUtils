//
//  RuntimeUtils.swift
//  LTXiOSUtils
//  运行时工具类
//  Created by CoderStar on 2021/8/20.
//

import Foundation

// MARK: - Class相关

public struct RuntimeUtils {
    /// 获取所有的class
    public static var allClasses: [AnyClass] {
        let numberOfClasses = Int(objc_getClassList(nil, 0))
        if numberOfClasses > 0 {
            let classesPtr = UnsafeMutablePointer<AnyClass>.allocate(capacity: numberOfClasses)
            let autoreleasingClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(classesPtr)
            let count = objc_getClassList(autoreleasingClasses, Int32(numberOfClasses))
            assert(numberOfClasses == count, "")
            defer { classesPtr.deallocate() }
            return (0 ..< numberOfClasses).map { classesPtr[$0] }
        }
        return []
    }

    /// 获取指定类所有子类，注意会返回指定类自身
    ///
    /// - Parameter class: 指定类
    /// - Returns: 所有子类
    public static func subclasses(of class: AnyClass) -> [AnyClass] {
        return allClasses.filter {
            var ancestor: AnyClass? = $0
            while let type = ancestor {
                if ObjectIdentifier(type) == ObjectIdentifier(`class`) {
                    return true
                }
                ancestor = class_getSuperclass(type)
            }
            return false
        }
    }

    /// 判断一个类是不是另一个类的子类
    ///
    /// - Parameters:
    ///   - subclass: 子类
    ///   - superclass: 父类
    /// - Returns: 结果
    public static func isSubclass(_ subclass: AnyClass, superclass: AnyClass) -> Bool {
        var eachSubclass = subclass
        while let eachSuperclass: AnyClass = class_getSuperclass(eachSubclass) {
            if ObjectIdentifier(eachSuperclass) == ObjectIdentifier(superclass) {
                return true
            }
            eachSubclass = eachSuperclass
        }
        return false
    }
}

// MARK: - 协议相关

extension RuntimeUtils {
    /// 判断一个类是否符合一个协议
    ///
    /// - Parameters:
    ///   - baseclass: 类
    ///   - baseProtocol: 协议
    /// - Returns: 是否符合
    public static func confirm(_ baseclass: AnyClass, confirm baseProtocol: Protocol) -> Bool {
        var eachSubclass: AnyClass = baseclass
        if class_conformsToProtocol(baseclass, baseProtocol) {
            return true
        }
        while let eachSuperclass: AnyClass = class_getSuperclass(eachSubclass) {
            if class_conformsToProtocol(eachSuperclass, baseProtocol) {
                return true
            }
            eachSubclass = eachSuperclass
        }
        return false
    }

    /// 获取实现某协议的所有类
    ///
    /// - Parameter baseProtocol: 协议
    /// - Returns: 类数组
    public static func getAllClasses(confirm baseProtocol: Protocol) -> [AnyClass] {
        var proResult = [AnyClass]()

        let count: Int32 = objc_getClassList(nil, 0)

        guard count > 0 else {
            return proResult
        }

        let classes = UnsafeMutablePointer<AnyClass>.allocate(
            capacity: Int(count)
        )

        defer {
            classes.deallocate()
        }

        let buffer = AutoreleasingUnsafeMutablePointer<AnyClass>(classes)
        for i in 0 ..< Int(objc_getClassList(buffer, count)) {
            let someclass: AnyClass = classes[i]
            // 这个判断是防止oc调用该方式时出现`methodSignatureForSelector`以及`doesNotRecognizeSelector` does not implement问题
            if class_getInstanceMethod(someclass, NSSelectorFromString("methodSignatureForSelector:")) != nil,
               class_getInstanceMethod(someclass, NSSelectorFromString("doesNotRecognizeSelector:")) != nil {
                if confirm(someclass, confirm: baseProtocol) {
                    proResult.append(someclass)
                }
            }
        }
        return proResult
    }
}

// MARK: - 方法相关

extension RuntimeUtils {}
