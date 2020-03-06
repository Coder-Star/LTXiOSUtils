//
//  UIViewExtensions.swift
//  LTXiOSUtils
//  UIView工具类与扩展
//  Created by 李天星 on 2019/11/18.
//

import Foundation

// MARK: - view绑定数据
public extension UIView {
    private struct UIViewAssociatedKey {
        static var dataStr: Void?
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
public extension UIView {
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
    func getSubView(name: String) -> [UIView] {
        UIView.allSubviews = []
        let viewArr = viewArray(root: self)
        return viewArr.filter {$0.className == name}
    }

    /// 获取所有子视图
    func getAllSubViews() -> [UIView] {
        UIView.allSubviews = []
        return viewArray(root: self)
    }

    /// 移除所有子视图
    func removeAllChildView() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
    }

    /// 同时添加多个视图
    func add(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}

public extension UIView {

    /// 设置View部分圆角,若使用自动布局，应在设置宽高约束后使用
    /// 示例：view.setCorner(size:5, roundingCorners:[.topLeft,.topRight])，
    /// - Parameters:
    ///   - size: 圆角大小
    ///   - roundingCorners: 圆角位置
    func setCorner(size: CGFloat, roundingCorners: UIRectCorner) {
        self.layoutIfNeeded()
        let fieldPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: size, height: size) )
        let fieldLayer = CAShapeLayer()
        fieldLayer.frame = self.bounds
        fieldLayer.path = fieldPath.cgPath
        self.layer.mask = fieldLayer
    }
}

// MARK: - 闭包实现view操作手势的链式监听，建议使用这个，内部加入了防重复点击
public extension UIView {

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
    typealias GestureClosures = (UIGestureRecognizer) -> Void

    /// 点击
    /// - Parameters:
    ///   - disEnabledtimeInterval: 不可用时间，默认时间为0.5s
    ///   - gesture: 手势回调
    @discardableResult
    func addTapGesture(disEnabledtimeInterval: CGFloat = 0.5, _ gesture: @escaping GestureClosures) -> UIView {
        addGesture(gesture: gesture, for: .tapGesture, disEnabledtimeInterval: disEnabledtimeInterval)
        return self
    }
    /// 捏合
    @discardableResult
    func addPinchGesture(_ gesture: @escaping GestureClosures) -> UIView {
        addGesture(gesture: gesture, for: .pinchGesture)
        return self
    }
    /// 旋转
    @discardableResult
    func addRotationGesture(_ gesture: @escaping GestureClosures) -> UIView {
        addGesture(gesture: gesture, for: .rotationGesture)
        return self
    }
    /// 滑动
    @discardableResult
    func addSwipeGesture(_ gesture: @escaping GestureClosures) -> UIView {
        addGesture(gesture: gesture, for: .swipeGesture)
        return self
    }
    /// 拖动
    @discardableResult
    func addPanGesture(_ gesture: @escaping GestureClosures) -> UIView {
        addGesture(gesture: gesture, for: .panGesture)
        return self
    }
    /// 长按
    @discardableResult
    func addLongPressGesture(_ gesture: @escaping GestureClosures) -> UIView {
        addGesture(gesture: gesture, for: .longPressGesture)
        return self
    }

    private func addGesture(gesture: @escaping GestureClosures, for gestureType: GestureType, disEnabledtimeInterval: CGFloat = 0.0) {
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
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)), disEnabledtimeInterval: disEnabledtimeInterval)
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
    @objc
    private func tapGestureAction (_ tap: UITapGestureRecognizer) {
        executeGestureAction(.tapGesture, gesture: tap)
    }
    @objc
    private func pinchGestureAction (_ pinch: UIPinchGestureRecognizer) {
        executeGestureAction(.pinchGesture, gesture: pinch)
    }
    @objc
    private func rotationGestureAction (_ rotation: UIRotationGestureRecognizer) {
        executeGestureAction(.rotationGesture, gesture: rotation)
    }
    @objc
    private func swipeGestureAction (_ swipe: UISwipeGestureRecognizer) {
        executeGestureAction(.swipeGesture, gesture: swipe)
    }
    @objc
    private func panGestureAction (_ pan: UIPanGestureRecognizer) {
        executeGestureAction(.panGesture, gesture: pan)
    }
    @objc
    private func longPressGestureAction (_ longPress: UILongPressGestureRecognizer) {
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

// MARK: - UITapGestureRecognizer添加不可用时间间隔
extension UITapGestureRecognizer: UIGestureRecognizerDelegate {
    private struct UITapGestureDictKey {
        static var key: Void?
    }

    /// 不可用时间间隔
    public var disEnabledtimeInterval: CGFloat? {
        set {
            objc_setAssociatedObject(self, &UITapGestureDictKey.key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            self.delegate = self
        }
        get {
            return  objc_getAssociatedObject(self, &UITapGestureDictKey.key) as? CGFloat
        }
    }

    public convenience init(target: Any?, action: Selector?, disEnabledtimeInterval: CGFloat) {
        self.init(target: target, action: action)
        self.disEnabledtimeInterval = disEnabledtimeInterval
        self.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        self.isEnabled = false
        let time: TimeInterval = TimeInterval(disEnabledtimeInterval ?? 0.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.isEnabled = true
        }
        return true
    }
}
