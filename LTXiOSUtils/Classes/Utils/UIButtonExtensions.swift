//
//  UIButtonExtensions.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/12/16.
//

import Foundation
import UIKit

// MARK: - 按钮防重复点击处理
// app启动时需要调用一下UIButton.initializeMethod()
// 分为两种模式，一种是时间等候模式，一种事件完成模式，事件完成之后需要重新将isFinishEvent赋值为false才可以让按钮再进行响应
extension UIButton {
    /// 时间等待模式默认的等待时间 0.5s
    static let defaultDuration = 0.5

    /// 使用模式
    public enum RepeatButtonClickType: String {
        /// 时间等候模式，默认
        case durationTime
        /// 事件完成模式
        case eventDone
    }

    private struct AssociatedKeysWithUIButtonMultiClick {
        static var clickDurationTime: Void?
        static var isIgnoreEvent: Void?
        static var isFinish: Void?
        static var repeatButtonClickType: Void?
    }

    /// 使用模式
    public var repeatButtonClickType: RepeatButtonClickType {
        set {
            objc_setAssociatedObject(self, &AssociatedKeysWithUIButtonMultiClick.repeatButtonClickType, newValue as RepeatButtonClickType, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let clickDurationTime = objc_getAssociatedObject(self, &AssociatedKeysWithUIButtonMultiClick.repeatButtonClickType) as? RepeatButtonClickType {
                return clickDurationTime
            }
            return .durationTime
        }
    }

    /// 点击间隔时间
    public var clickDurationTime: TimeInterval {
        set {
            objc_setAssociatedObject(self, &AssociatedKeysWithUIButtonMultiClick.clickDurationTime, newValue as TimeInterval, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let clickDurationTime = objc_getAssociatedObject(self, &AssociatedKeysWithUIButtonMultiClick.clickDurationTime) as? TimeInterval {
                return clickDurationTime
            }
            return UIButton.defaultDuration
        }
    }

    /// 是否完成点击事件
       public var isFinishEvent: Bool {
           set {
               objc_setAssociatedObject(self, &AssociatedKeysWithUIButtonMultiClick.isFinish, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
           }
           get {
               if let isFinishEvent = objc_getAssociatedObject(self, &AssociatedKeysWithUIButtonMultiClick.isFinish) as? Bool {
                   return isFinishEvent
               }
               return false
           }
       }

    /// 是否忽视点击事件
    private var isIgnoreEvent: Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKeysWithUIButtonMultiClick.isIgnoreEvent, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let isIgnoreEvent = objc_getAssociatedObject(self, &AssociatedKeysWithUIButtonMultiClick.isIgnoreEvent) as? Bool {
                return isIgnoreEvent
            }
            return false
        }
    }

    ///
    /// - Parameters:
    ///   - action: 执行函数
    ///   - target: 执行者
    ///   - event: 事件
    @objc public func my_sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        if (self.isKind(of: UIButton.self)) {
            switch self.repeatButtonClickType {
            case .durationTime:
                clickDurationTime = clickDurationTime == 0 ? UIButton.defaultDuration : clickDurationTime
                if isIgnoreEvent {
                    return
                } else if clickDurationTime > 0 {
                    isIgnoreEvent = true
                    DispatchQueue.global(qos: .default).delay(clickDurationTime) {
                        self.isIgnoreEvent = false
                    }
                    DispatchQueue.main.delay(clickDurationTime) {
                        self.isIgnoreEvent = false
                    }
                    my_sendAction(action: action, to: target, forEvent: event)
                }
            case .eventDone:
                if !isFinishEvent {
                    my_sendAction(action: action, to: target, forEvent: event)
                    isFinishEvent = true
                }
            }
        } else {
            my_sendAction(action: action, to: target, forEvent: event)
        }
    }

    /// 初始化，需手动调用一下
    public class func initializeMethod() {
        if self !== UIButton.self {
            return
        }
        DispatchQueue.once(token: "AssociatedKeysWithUIButtonMultiClick") {
            let originalSelector = #selector(UIButton.sendAction)
            let swizzledSelector = #selector(UIButton.my_sendAction(action:to:forEvent:))

            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)

            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))

            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }

}
