//
//  WKWebViewExtensions.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/4/16.
//

import Foundation
import UIKit
import WebKit

extension TxExtensionWrapper where Base: WKWebView {
    private class WKWebViewInputAccessoryView {
        @objc
        var inputAccessoryView: AnyObject? {
            return nil
        }
    }

    /// 移除键盘inputAccessoryView
    public func removeInputAccessoryView() {
        guard let target = base.scrollView.subviews.first(where: {
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

extension TxExtensionWrapper where Base: WKWebView {
    /// 用户是否需要点击才能聚焦，弹出键盘
    /// 默认为true，即必须需要点击才能聚焦
    /// 这个属性UIWebview有，WKWebView要自己实现
    public var keyboardDisplayRequiresUserAction: Bool? {
        get {
            return self.keyboardDisplayRequiresUserAction
        }
        set {
            setKeyboardRequiresUserInteraction(newValue ?? true)
        }
    }

    private typealias OlderClosureType = @convention(c) (Any, Selector, UnsafeRawPointer, Bool, Bool, Any?) -> Void
    private typealias NewerClosureType = @convention(c) (Any, Selector, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void

    private func setKeyboardRequiresUserInteraction(_ value: Bool) {
        guard let WKContentViewClass = NSClassFromString("WKContentView") else {
            return
        }

        let olderSelector: Selector = sel_getUid("_startAssistingNode:userIsInteracting:blurPreviousNode:userObject:")
        let newSelector: Selector = sel_getUid("_startAssistingNode:userIsInteracting:blurPreviousNode:changingActivityState:userObject:")
        let newerSelector: Selector = sel_getUid("_elementDidFocus:userIsInteracting:blurPreviousNode:changingActivityState:userObject:")
        let ios13Selector: Selector = sel_getUid("_elementDidFocus:userIsInteracting:blurPreviousNode:activityStateChanges:userObject:")

        if let method = class_getInstanceMethod(WKContentViewClass, olderSelector) {
            let originalImp: IMP = method_getImplementation(method)
            let original: OlderClosureType = unsafeBitCast(originalImp, to: OlderClosureType.self)
            let block: @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Any?) -> Void = { me, arg0, _, arg2, arg3 in
                original(me, olderSelector, arg0, !value, arg2, arg3)
            }
            let imp: IMP = imp_implementationWithBlock(block)
            method_setImplementation(method, imp)
        }

        if let method = class_getInstanceMethod(WKContentViewClass, newSelector) {
            swizzleAutofocusMethod(method, newSelector, value)
        }

        if let method = class_getInstanceMethod(WKContentViewClass, newerSelector) {
            swizzleAutofocusMethod(method, newerSelector, value)
        }

        if let method = class_getInstanceMethod(WKContentViewClass, ios13Selector) {
            swizzleAutofocusMethod(method, ios13Selector, value)
        }
    }

    private func swizzleAutofocusMethod(_ method: Method, _ selector: Selector, _ value: Bool) {
        let originalImp: IMP = method_getImplementation(method)
        let original: NewerClosureType = unsafeBitCast(originalImp, to: NewerClosureType.self)
        let block: @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void = { me, arg0, _, arg2, arg3, arg4 in
            original(me, selector, arg0, !value, arg2, arg3, arg4)
        }
        let imp: IMP = imp_implementationWithBlock(block)
        method_setImplementation(method, imp)
    }
}
