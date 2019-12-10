//
//  ViewExtensions.swift
//  LTXiOSUtils
//  UIView工具类与扩展
//  Created by 李天星 on 2019/11/18.
//

import Foundation
import SwiftyJSON

// MARK: - view绑定数据
extension UIView {
    private struct UIViewAssociatedKey {
        static var dataStr: Void?
        static var dataJSON: Void?
        static var dataAny: Void?
    }

    /// 为view绑定字符串数据
    var dataStr: String {
        set {
            objc_setAssociatedObject(self, &UIViewAssociatedKey.dataStr, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if let rs = objc_getAssociatedObject(self, &UIViewAssociatedKey.dataStr) as? String {
                return rs
            }
            return ""
        }
    }

    /// 为view绑定json数据
    var dataJSON: JSON {
        set {
            objc_setAssociatedObject(self, &UIViewAssociatedKey.dataJSON, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if let rs = objc_getAssociatedObject(self, &UIViewAssociatedKey.dataJSON) as? JSON {
                return rs
            }
            return JSON()
        }
    }

    /// 为view绑定Any类型数据
    var dataAny: Any {
        set {
            objc_setAssociatedObject(self, &UIViewAssociatedKey.dataAny, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if let rs = objc_getAssociatedObject(self, &UIViewAssociatedKey.dataAny) {
                return rs
            }
            return Any.self
        }
    }

}

// MARK: - view视图相关
extension UIView {
    private static var allSubviews: [UIView] = []

    // 递归遍历view的所有子孙view，深度优先遍历
    private func viewArray(root: UIView) -> [UIView] {
        for view in root.subviews {
            if view.isKind(of: UIView.self) {
                UIView.allSubviews.append(view)
            }
            _ = viewArray(root: view)
        }
        return UIView.allSubviews
    }

    /// 获取指定子视图
    public func getSubView(name: String) -> [UIView] {
        UIView.allSubviews = []
        let viewArr = viewArray(root: self)
        return viewArr.filter {$0.className == name}
    }

    /// 获取所有子视图
    public func getAllSubViews() -> [UIView] {
        UIView.allSubviews = []
        return viewArray(root: self)
    }

    /// 移除所有子视图
    public func removeAllChildView() {
        _ = self.subviews.map {
            $0.removeFromSuperview()
        }
    }

    /// 同时添加多个视图
    public func add(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}

extension UIView {

    /// 设置View部分圆角,若使用自动布局，应在设置宽高约束后使用
    /// 示例：view.setCorner(size:5, roundingCorners:[.topLeft,.topRight])，
    /// - Parameters:
    ///   - size: 圆角大小
    ///   - roundingCorners: 圆角位置
    public func setCorner(size: CGFloat, roundingCorners: UIRectCorner) {
        self.layoutIfNeeded()
        let fieldPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: size, height: size) )
        let fieldLayer = CAShapeLayer()
        fieldLayer.frame = self.bounds
        fieldLayer.path = fieldPath.cgPath
        self.layer.mask = fieldLayer
    }
}

// MARK: - 闭包实现view操作手势的链式监听
extension UIView {

    private struct GestureDictKey {
        static var key: Void?
    }

    private enum GestureType: String {
        case tapGesture
        case pinchGesture
        case rotationGesture
        case swipeGesture
        case panGesture
        case longPressGesture
    }
    private var gestureDict: [String: GestureClosures]? {
        get {
            return objc_getAssociatedObject(self, &GestureDictKey.key) as? [String: GestureClosures]
        }
        set {
            objc_setAssociatedObject(self, &GestureDictKey.key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    /// 闭包
    public typealias GestureClosures = (UIGestureRecognizer) -> Void

    /// 点击
    @discardableResult
    public func addTapGesture(_ gesture: @escaping GestureClosures) -> UIView {
        addGesture(gesture: gesture, for: .tapGesture)
        return self
    }
    /// 捏合
    @discardableResult
    public func addPinchGesture(_ gesture: @escaping GestureClosures) -> UIView {
        addGesture(gesture: gesture, for: .pinchGesture)
        return self
    }
    /// 旋转
    @discardableResult
    public func addRotationGesture(_ gesture: @escaping GestureClosures) -> UIView {
        addGesture(gesture: gesture, for: .rotationGesture)
        return self
    }
    /// 滑动
    @discardableResult
    public func addSwipeGesture(_ gesture: @escaping GestureClosures) -> UIView {
        addGesture(gesture: gesture, for: .swipeGesture)
        return self
    }
    /// 拖动
    @discardableResult
    public func addPanGesture(_ gesture: @escaping GestureClosures) -> UIView {
        addGesture(gesture: gesture, for: .panGesture)
        return self
    }
    /// 长按
    @discardableResult
    public func addLongPressGesture(_ gesture: @escaping GestureClosures) -> UIView {
        addGesture(gesture: gesture, for: .longPressGesture)
        return self
    }

    private func addGesture(gesture: @escaping GestureClosures, for gestureType: GestureType) {
        let gestureKey = String(gestureType.rawValue)
        if var gestureDict = self.gestureDict {
            gestureDict.updateValue(gesture, forKey: gestureKey)
            self.gestureDict = gestureDict
        } else {
            self.gestureDict = [gestureKey: gesture]
        }
        isUserInteractionEnabled = true
        switch gestureType {
        case .tapGesture:
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
            addGestureRecognizer(tap)
        case .pinchGesture:
            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureAction(_:)))
            addGestureRecognizer(pinch)
        case .rotationGesture:
            let rotation = UIRotationGestureRecognizer(target: self, action: #selector(rotationGestureAction(_:)))
            addGestureRecognizer(rotation)
        case .swipeGesture:
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureAction(_:)))
            addGestureRecognizer(swipe)
        case .panGesture:
            let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
            addGestureRecognizer(pan)
        case .longPressGesture:
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureAction(_:)))
            addGestureRecognizer(longPress)
        }
    }
    @objc private func tapGestureAction (_ tap: UITapGestureRecognizer) {
        executeGestureAction(.tapGesture, gesture: tap)
    }
    @objc private func pinchGestureAction (_ pinch: UIPinchGestureRecognizer) {
        executeGestureAction(.pinchGesture, gesture: pinch)
    }
    @objc private func rotationGestureAction (_ rotation: UIRotationGestureRecognizer) {
        executeGestureAction(.rotationGesture, gesture: rotation)
    }
    @objc private func swipeGestureAction (_ swipe: UISwipeGestureRecognizer) {
        executeGestureAction(.swipeGesture, gesture: swipe)
    }
    @objc private func panGestureAction (_ pan: UIPanGestureRecognizer) {
        executeGestureAction(.panGesture, gesture: pan)
    }
    @objc private func longPressGestureAction (_ longPress: UILongPressGestureRecognizer) {
        if longPress.state != .began {
            return
        }
        executeGestureAction(.longPressGesture, gesture: longPress)
    }
    private func executeGestureAction(_ gestureType: GestureType, gesture: UIGestureRecognizer) {
        let gestureKey = String(gestureType.rawValue)
        if let gestureDict = self.gestureDict, let gestureReg = gestureDict[gestureKey] {
            gestureReg(gesture)
        }
    }
}
