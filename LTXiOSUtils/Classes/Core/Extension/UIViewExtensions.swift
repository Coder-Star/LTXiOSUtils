//
//  UIViewExtensions.swift
//  LTXiOSUtils
//  UIView工具类与扩展
//  Created by 李天星 on 2019/11/18.
//

import Foundation

// MARK: - view绑定数据
extension UIView {

    private struct UIViewAssociatedKey {
        static var dataStr: Void?
        static var dataAny: Void?
    }

    /// 为view绑定字符串数据
    public var dataStr: String {
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
    public var dataAny: Any {
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
        return viewArr.filter {$0.tx.className == name}
    }

    /// 获取所有子视图
    public func getAllSubViews() -> [UIView] {
        UIView.allSubviews = []
        return viewArray(root: self)
    }

    /// 移除所有子视图
    public func removeAllSubview() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
    }

    /// 同时添加多个视图
    public func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }

    /// 获取最近的指定view类型的父view
    /// - Parameter viewType: view类型
    public func getParentView(viewType: AnyClass) -> UIView? {
        var tempView = self.superview
        var resultView: UIView?
        while tempView != nil {
            if tempView?.isKind(of: viewType) ?? false {
                resultView = tempView
                break
            }
            tempView = tempView?.superview
        }
        return resultView
    }

    /// 获取view所在的ViewController
    public var firstViewController: UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next, responder.isKind(of: UIViewController.self) {
                return responder as? UIViewController
            }
        }
        return nil
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

// MARK: - 闭包实现view操作手势的链式监听，建议使用这个，内部加入了防重复点击
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
    /// - Parameters:
    ///   - disEnabledtimeInterval: 不可用时间，默认时间为0.5s
    ///   - gesture: 手势回调
    @discardableResult
    public func addTapGesture(disEnabledtimeInterval: CGFloat = 0.5, _ gesture: @escaping GestureClosures) -> UIView {
        addGesture(gesture: gesture, for: .tapGesture, disEnabledtimeInterval: disEnabledtimeInterval)
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
    func addPanGesture(_ gesture: @escaping GestureClosures) -> UIView {
        addGesture(gesture: gesture, for: .panGesture)
        return self
    }

    /// 长按
    @discardableResult
    public func addLongPressGesture(_ gesture: @escaping GestureClosures) -> UIView {
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
    private var disEnabledtimeInterval: CGFloat? {
        set {
            objc_setAssociatedObject(self, &UITapGestureDictKey.key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, &UITapGestureDictKey.key) as? CGFloat
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
        self.delegate = self
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

// MARK: - 设置frame相关扩展
extension TxExtensionWrapper where Base: UIView {

    /// 扩展 x 的 set get 方法
    public var x: CGFloat {
        get {
            return base.frame.origin.x
        }
        set(newX) {
            var tmpFrame: CGRect = base.frame
            tmpFrame.origin.x = newX
            base.frame = tmpFrame
        }
    }

    /// 扩展 y 的 set get 方法
    public var y: CGFloat {
        get {
            return base.frame.origin.y
        }
        set(newY) {
            var tmpFrame: CGRect = base.frame
            tmpFrame.origin.y = newY
            base.frame = tmpFrame
        }
    }

    /// 扩展 width 的 set get 方法
    public var width: CGFloat {
        get {
            return base.frame.size.width
        }
        set(newWidth) {
            var tmpFrameWidth: CGRect = base.frame
            tmpFrameWidth.size.width = newWidth
            base.frame = tmpFrameWidth
        }
    }

    /// 扩展 height 的 set get 方法
    public var height: CGFloat {
        get {
            return base.frame.size.height
        }
        set(newHeight) {
            var tmpFrameHeight: CGRect = base.frame
            tmpFrameHeight.size.height = newHeight
            base.frame = tmpFrameHeight
        }
    }

    /// 扩展 centerX 的 set get 方法
    public var centerX: CGFloat {
        get {
            return base.center.x
        }
        set(newCenterX) {
            base.center = CGPoint(x: newCenterX, y: base.center.y)
        }
    }

    /// 扩展 centerY 的 set get 方法
    public var centerY: CGFloat {
        get {
            return base.center.y
        }
        set(newCenterY) {
            base.center = CGPoint(x: base.center.x, y: newCenterY)
        }
    }

    /// 扩展 origin 的 set get 方法
    public var origin: CGPoint {
        get {
            return CGPoint(x: x, y: y)
        }
        set(newOrigin) {
            x = newOrigin.x
            y = newOrigin.y
        }
    }

    /// 扩展 size 的 set get 方法
    public var size: CGSize {
        get {
            return CGSize(width: width, height: height)
        }
        set(newSize) {
            width = newSize.width
            height = newSize.height
        }
    }

    /// 扩展 left 的 set get 方法
    public var left: CGFloat {
        get {
            return x
        }
        set(newLeft) {
            x = newLeft
        }
    }

    /// 扩展 right 的 set get 方法
    public var right: CGFloat {
        get {
            return x + width
        }
        set(newNight) {
            x = newNight - width
        }
    }

    /// 扩展 top 的 set get 方法
    public var top: CGFloat {
        get {
            return y
        }
        set(newTop) {
            y = newTop
        }
    }

    /// 扩展 bottom 的 set get 方法
    public var bottom: CGFloat {
        get {
            return y + height
        }
        set(newBottom) {
            y = newBottom - height
        }
    }
}

// MARK: - 扩大UIView子类的点击热区
extension UIView {
    private struct HitDictKey {
        static var top: Void?
        static var right: Void?
        static var bottom: Void?
        static var left: Void?
    }

    private var hitTop: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &HitDictKey.top) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &HitDictKey.top, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    private var hitRight: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &HitDictKey.right) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &HitDictKey.right, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    private var hitBottom: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &HitDictKey.bottom) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &HitDictKey.bottom, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    private var hitLeft: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &HitDictKey.left) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &HitDictKey.left, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    /// 扩大点击区域，设置的值为正整数
    /// 此方法只对UIView的子类起作用，目前支持UIImageView及UILabel
    /// - Parameters:
    ///   - top: 顶部扩大长度
    ///   - right: 右边扩大长度
    ///   - bottom: 底部扩大长度
    ///   - left: 左边扩大长度
    public func setEnlargeEdge(top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
        hitTop = top
        hitRight = right
        hitBottom = bottom
        hitLeft = left
    }

    fileprivate func checkEnlargeEdge(_ point: CGPoint) -> Bool? {
        if let topEdge = hitTop, let rightEdge = hitRight, let bottomEdge = hitBottom, let leftEdge = hitLeft {
            return CGRect(x: bounds.origin.x - leftEdge, y: bounds.origin.y - topEdge, width: bounds.width + leftEdge + rightEdge, height: bounds.height + topEdge + bottomEdge).contains(point)
        }
        return nil
    }

}

// MARK: - 增大UIImageView点击热区
extension UIImageView {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !self.isUserInteractionEnabled || self.alpha <= 0.01 || self.isHidden {
            return nil
        }
        if let isEnlarge = checkEnlargeEdge(point) {
            if isEnlarge {
                return self
            } else {
                return nil
            }
        }
        return super.hitTest(point, with: event)
    }
}

// MARK: - 增大UILabel点击热区
extension UILabel {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !self.isUserInteractionEnabled || self.alpha <= 0.01 || self.isHidden {
            return nil
        }
        if let isEnlarge = checkEnlargeEdge(point) {
            if isEnlarge {
                return self
            } else {
                return nil
            }
        }
        return super.hitTest(point, with: event)
    }
}

// MARK: - 增大UIControl点击热区
extension UIControl {

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !self.isUserInteractionEnabled || self.alpha <= 0.01 || self.isHidden || !self.isEnabled {
            return nil
        }
        if let isEnlarge = checkEnlargeEdge(point) {
            if isEnlarge {
                return self
            } else {
                return nil
            }
        }
        return super.hitTest(point, with: event)
    }
}

// MARK: - IB支持配置动态属性
extension UIView {
    /// 圆角
    @IBInspectable
    public var cornerRadius: CGFloat {
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    /// 边框宽度
    @IBInspectable
    public var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    /// 边框颜色
    @IBInspectable
    public var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.black.cgColor)
        }
    }
}
