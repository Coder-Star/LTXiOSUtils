//
//  UIButtonExtensions.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/12/16.
//

import Foundation
import UIKit

// MARK: - 按钮防重复点击处理
// app启动时需要调用一下UIButton.initRepeatClickMethod()
// 分为两种模式，一种是时间等候模式，一种事件完成模式，事件完成之后需要重新将isFinishEvent赋值为false才可以让按钮再进行响应
extension UIButton {
    /// 时间等待模式默认的等待时间 0.5s
    public static var RepeatClickDefaultDuration = 0.5

    /// 使用模式
    public enum RepeatButtonClickType: String {
        /// 时间等候模式，默认
        case durationTime
        /// 事件完成模式
        case eventDone
    }

    private struct AssociatedKeysWithUIButtonRepeatClick {
        static var clickDurationTime: Void?
        static var isIgnoreEvent: Void?
        static var isFinish: Void?
        static var repeatButtonClickType: Void?
    }

    /// 使用模式
    public var repeatButtonClickType: RepeatButtonClickType {
        set {
            objc_setAssociatedObject(self, &AssociatedKeysWithUIButtonRepeatClick.repeatButtonClickType, newValue as RepeatButtonClickType, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let clickDurationTime = objc_getAssociatedObject(self, &AssociatedKeysWithUIButtonRepeatClick.repeatButtonClickType) as? RepeatButtonClickType {
                return clickDurationTime
            }
            return .durationTime
        }
    }

    /// 点击间隔时间
    public var clickDurationTime: TimeInterval {
        set {
            objc_setAssociatedObject(self, &AssociatedKeysWithUIButtonRepeatClick.clickDurationTime, newValue as TimeInterval, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let clickDurationTime = objc_getAssociatedObject(self, &AssociatedKeysWithUIButtonRepeatClick.clickDurationTime) as? TimeInterval {
                return clickDurationTime
            }
            return UIButton.RepeatClickDefaultDuration
        }
    }

    /// 是否完成点击事件
    public var isFinishEvent: Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKeysWithUIButtonRepeatClick.isFinish, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let isFinishEvent = objc_getAssociatedObject(self, &AssociatedKeysWithUIButtonRepeatClick.isFinish) as? Bool {
                return isFinishEvent
            }
            return false
        }
    }

    /// 是否忽视点击事件
    private var isIgnoreEvent: Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKeysWithUIButtonRepeatClick.isIgnoreEvent, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let isIgnoreEvent = objc_getAssociatedObject(self, &AssociatedKeysWithUIButtonRepeatClick.isIgnoreEvent) as? Bool {
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
    @objc
    private func sendActionWithRepeatClick(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        if self.isKind(of: UIButton.self) {
            switch self.repeatButtonClickType {
            case .durationTime:
                clickDurationTime = clickDurationTime == 0 ? UIButton.RepeatClickDefaultDuration : clickDurationTime
                if isIgnoreEvent {
                    return
                } else if clickDurationTime > 0 {
                    isIgnoreEvent = true
                    DispatchQueue.global(qos: .default).tx.delay(clickDurationTime) {
                        self.isIgnoreEvent = false
                    }
                    DispatchQueue.main.tx.delay(clickDurationTime) {
                        self.isIgnoreEvent = false
                    }
                    /// 因为进行了imp互换，所以此时调用方法会执行sendAction方法
                    sendActionWithRepeatClick(action: action, to: target, forEvent: event)
                }
            case .eventDone:
                if !isFinishEvent {
                    sendActionWithRepeatClick(action: action, to: target, forEvent: event)
                    isFinishEvent = true
                }
            }
        } else {
            sendActionWithRepeatClick(action: action, to: target, forEvent: event)
        }
    }

    /// 初始化，需手动调用一下
    public class func initRepeatClickMethod() {
        if self !== UIButton.self {
            return
        }
        // 保证方法只交换一次
        DispatchQueue.tx.once(token: "AssociatedKeysWithUIButtonRepeatClick") {
            let originalSelector = #selector(UIButton.sendAction)
            let swizzledSelector = #selector(UIButton.sendActionWithRepeatClick(action:to:forEvent:))

            // 原有方法，通过方法编号找到方法
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            // 现有方法
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            // 先尝试給原有SEL添加新IMP，这里是为了避免原有SEL没有实现IMP的情况
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))

            if didAddMethod {
                // 添加成功，说明原SEL没有实现IMP，添加成功后将新的SEL的IMP替换成老IMPΩ
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                // 添加失败，说明原SEL已经实现了IMP，直接将两个SEL的IMP实现交换即可
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }

}

// MARK: - Button所有事件的链式调用
extension UIButton {

    private struct ActionDictKey {
        static var key: Void?
    }

    /// 闭包
    public typealias ButtonAction = (UIButton) -> Void

    // MARK: - 属性
    // 用于保存所有事件对应的闭包
    private var actionDict: [String: ButtonAction]? {
        get {
            return objc_getAssociatedObject(self, &ActionDictKey.key) as? [String: ButtonAction]
        }
        set {
            objc_setAssociatedObject(self, &ActionDictKey.key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    // MARK: - 公开函数

    /// 按钮点击事件
    /// - Parameter action: 回调
    @discardableResult
    public func addTouchUpInsideAction(_ action: @escaping ButtonAction) -> UIButton {
        self.addAction(action: action, for: .touchUpInside)
        return self
    }

    /// 按钮事件
    /// - Parameters:
    ///   - event: 事件类型
    ///   - action: 回调
    @discardableResult
    public func addAction(event: UIControl.Event, _ action: @escaping ButtonAction) -> UIButton {
        self.addAction(action: action, for: event)
        return self
    }

    // MARK: - 私有方法
    private func addAction(action: @escaping ButtonAction, for controlEvents: UIControl.Event) {
        let eventKey = String(controlEvents.rawValue)
        if var actionDict = self.actionDict {
            actionDict.updateValue(action, forKey: eventKey)
            self.actionDict = actionDict
        } else {
            self.actionDict = [eventKey: action]
        }
        self.dataStr = "\(controlEvents.rawValue)"
        addTarget(self, action: #selector(respondControlEvent(button:)), for: controlEvents)
    }

    /// 响应事件
    @objc
    private func respondControlEvent(button: UIButton) {
        if let eventRawValue = UInt(button.dataStr) {
            executeControlEvent( UIControl.Event(rawValue: eventRawValue) )
        }
    }

    private func executeControlEvent(_ event: UIControl.Event) {
        let eventKey = String(event.rawValue)
        if let actionDict = self.actionDict, let action = actionDict[eventKey] {
            action(self)
        }
    }
}
