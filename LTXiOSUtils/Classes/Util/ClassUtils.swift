//
//  ClassUtils.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/8/20.
//

import Foundation

extension NSObject {
    /// 一个类的所有子类集合
    static func allSubclasses() -> [AnyClass] {
        var count: UInt32 = 0

        guard let classListPointer = objc_copyClassList(&count) else { return [] }
        return UnsafeBufferPointer(start: classListPointer, count: Int(count)).filter { class_getSuperclass($0) == self }
    }

    /// 一个类的所有子类名集合
    static var allSubclassNames: [String] {
        var classNames: [String] = []
        for item in allSubclasses() {
            classNames.append(String(describing: item.self))
        }
        return classNames
    }
}

final public class ClassUtils {
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
}
