//
//  FWPopupCategory.swift
//  FWPopupView
//
//  Created by xfg on 2018/3/20.
//  Copyright © 2018年 xfg. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

let kFwReferenceCountKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "fwReferenceCountKey".hashValue)
let kFwBackgroundViewKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "fwBackgroundViewKey".hashValue)
let kFwBackgroundViewColorKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "fwBackgroundViewColorKey".hashValue)
let kFwBackgroundAnimatingKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "fwBackgroundAnimatingKey".hashValue)
let kFwAnimationDurationKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "fwAnimationDurationKey".hashValue)

/// 遮罩层的默认背景色
let kDefaultMaskViewColor = UIColor(white: 0, alpha: 0.5)

extension UIView {

    var fwBackgroundAnimating: Bool {
        get {
            let isAnimating = objc_getAssociatedObject(self, kFwBackgroundAnimatingKey) as? Bool
            guard isAnimating != nil else {
                return false
            }
            return isAnimating!
        }
        set {
            objc_setAssociatedObject(self, kFwBackgroundAnimatingKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var fwAnimationDuration: TimeInterval {
        get {
            let duration = objc_getAssociatedObject(self, kFwAnimationDurationKey) as? TimeInterval
            guard duration != nil else {
                return 0.0
            }
            return duration!
        }
        set {
            objc_setAssociatedObject(self, kFwAnimationDurationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var fwReferenceCount: Int {
        get {
            let count = objc_getAssociatedObject(self, kFwReferenceCountKey) as? Int
            guard count != nil else {
                return 0
            }
            return count!
        }
        set {
            objc_setAssociatedObject(self, kFwReferenceCountKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 遮罩层颜色
    var fwMaskViewColor: UIColor {
        get {
            let color = objc_getAssociatedObject(self, kFwBackgroundViewColorKey) as? UIColor
            guard color != nil else {
                return kDefaultMaskViewColor
            }
            return color!
        }
        set {
            objc_setAssociatedObject(self, kFwBackgroundViewColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 遮罩层
    var fwMaskView: UIView {
        var tmpView = objc_getAssociatedObject(self, kFwBackgroundViewKey) as? UIView
        if tmpView == nil {
            tmpView = UIView(frame: self.bounds)
            self.addSubview(tmpView!)
            tmpView?.snp.makeConstraints { make in
                make.top.left.bottom.right.equalTo(self)
            }

            tmpView?.alpha = 0.0
            tmpView?.layer.zPosition = CGFloat(MAXFLOAT)
        }
        tmpView?.backgroundColor = fwMaskViewColor
        objc_setAssociatedObject(self, kFwBackgroundViewKey, tmpView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return tmpView!
    }

    /// 显示遮罩层
    func showFwBackground() {

        self.fwReferenceCount += 1
        if self.fwReferenceCount > 1 {
            self.fwReferenceCount -= 1
            return
        }
        self.fwMaskView.isHidden = false

        if self == FWPopupWindow.sharedInstance.attachView() {
            FWPopupWindow.sharedInstance.isHidden = false
            FWPopupWindow.sharedInstance.makeKeyAndVisible()
        } else if let window = self as? UIWindow {
            self.isHidden = false
            window.makeKeyAndVisible()
        } else {
            self.bringSubviewToFront(self.fwMaskView)
        }

        UIView.animate(withDuration: self.fwAnimationDuration, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            self.fwMaskView.alpha = 1.0
        }, completion: { _ in
        })
    }

    /// 隐藏遮罩层
    func hideFwBackground() {

        if self.fwReferenceCount > 1 {
            return
        }

        UIView.animate(withDuration: self.fwAnimationDuration, delay: 0, options: [.curveEaseIn, .beginFromCurrentState], animations: {
            self.fwMaskView.alpha = 0.0
        }, completion: { _ in
            if self == FWPopupWindow.sharedInstance.attachView() {
                FWPopupWindow.sharedInstance.isHidden = true
            } else if self.isKind(of: UIWindow.self) {
                self.isHidden = true
            }
            self.fwReferenceCount -= 1
        })
    }
}
