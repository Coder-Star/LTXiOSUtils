//
//  WKWebViewExtensions.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/4/16.
//

import Foundation
import WebKit

extension WKWebView {
    private class WKWebViewInputAccessoryView {
        @objc
        var inputAccessoryView: AnyObject? {
            return nil
        }
    }

    /// 移除键盘inputAccessoryView
    public func removeInputAccessoryView() {
        guard let target = scrollView.subviews.first(where: {
            String(describing: type(of: $0)).hasPrefix("WKContent")
        }), let superclass = target.superclass else {
            return
        }

        let noInputAccessoryViewClassName = "\(superclass)_NoInputAccessoryView"
        var newClass: AnyClass? = NSClassFromString(noInputAccessoryViewClassName)

        if newClass == nil, let targetClass = object_getClass(target), let classNameCString = noInputAccessoryViewClassName.cString(using: .ascii) {
            newClass = objc_allocateClassPair(targetClass, classNameCString, 0)

            if let newClass = newClass {
                objc_registerClassPair(newClass)
            }
        }

        guard let noInputAccessoryClass = newClass, let originalMethod = class_getInstanceMethod(WKWebViewInputAccessoryView.self, #selector(getter: WKWebViewInputAccessoryView.inputAccessoryView)) else {
            return
        }
        class_addMethod(noInputAccessoryClass.self, #selector(getter: WKWebViewInputAccessoryView.inputAccessoryView), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        object_setClass(target, noInputAccessoryClass)
    }
}
