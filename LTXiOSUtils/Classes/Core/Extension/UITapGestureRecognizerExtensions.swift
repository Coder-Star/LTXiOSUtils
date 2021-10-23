//
//  UITapGestureRecognizerExtensions.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/9/12.
//

import Foundation
import UIKit

// MARK: - UITapGestureRecognizer添加不可用时间间隔

extension UITapGestureRecognizer: UIGestureRecognizerDelegate {
    private struct UITapGestureDictKey {
        static var key: Void?
    }

    /// 不可用时间间隔
    private var disEnabledtimeInterval: CGFloat? {
        set {
            objc_setAssociatedObject(self, &UITapGestureDictKey.key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UITapGestureDictKey.key) as? CGFloat
        }
    }

    /// 防重复点击手势便利构造函数
    /// - Parameters:
    ///   - target: target
    ///   - action: action
    ///   - disEnabledtimeInterval: 不可点击时间
    public convenience init(target: Any?, action: Selector?, disEnabledtimeInterval: CGFloat) {
        self.init(target: target, action: action)
        self.disEnabledtimeInterval = disEnabledtimeInterval
        delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 延时禁用，防止认为手势未识别成功导致调用touch相关函数不正常
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.isEnabled = false
        }
        let time = TimeInterval(disEnabledtimeInterval ?? 0.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.isEnabled = true
        }
        return true
    }
}
