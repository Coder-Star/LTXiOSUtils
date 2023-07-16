//
//  UIViewExtensions.swift
//  LTXiOSUtils
//  UIView工具类与扩展
//  Created by CoderStar on 2019/11/18.
//

import Foundation
import UIKit

// MARK: - 未使用命名空间

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
        return viewArr.filter { $0.tx.className == name }
    }

    /// 获取所有子视图
    public func getAllSubViews() -> [UIView] {
        UIView.allSubviews = []
        return viewArray(root: self)
    }

    /// 移除所有子视图
    public func removeAllSubview() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }

    /// 同时添加多个视图
    /// - Parameter subviews: 子视图数组
    public func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }

    /// 获取最近的指定view类型的父view
    /// - Parameter viewType: view类型
    public func getParentView(viewType: AnyClass) -> UIView? {
        var tempView = superview
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
    ///
    /// 利用UIResponder的next，即响应链机制
    public var firstViewController: UIViewController? {
        for view in sequence(first: superview, next: { $0?.superview }) {
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
        layoutIfNeeded()
        let fieldPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: size, height: size))
        let fieldLayer = CAShapeLayer()
        fieldLayer.frame = bounds
        fieldLayer.path = fieldPath.cgPath
        layer.mask = fieldLayer
    }

    /// 添加4个不同大小的圆角
    public func setCorner(cornerRadii: CornerRadii) {
        layoutIfNeeded()
        let path = createPathWithRoundedRect(bounds: bounds, cornerRadii: cornerRadii)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = path
        layer.mask = shapeLayer
    }

    /// 移除CAShapeLayer画的圆角
    public func removeCorner() {
        if let mask = layer.mask, mask.isKind(of: CAShapeLayer.self) {
            layer.mask = nil
        }
    }

    /// 各圆角大小
    public struct CornerRadii {
        var topLeft: CGFloat = 0
        var topRight: CGFloat = 0
        var bottomLeft: CGFloat = 0
        var bottomRight: CGFloat = 0
        
        public init(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
            self.topLeft = topLeft
            self.topRight = topRight
            self.bottomLeft = bottomLeft
            self.bottomRight = bottomRight
        }
    }

    /// 切圆角函数绘制线条
    private func createPathWithRoundedRect(bounds: CGRect, cornerRadii: CornerRadii) -> CGPath {
        let minX = bounds.minX
        let minY = bounds.minY
        let maxX = bounds.maxX
        let maxY = bounds.maxY

        // 获取四个圆心
        let topLeftCenterX = minX + cornerRadii.topLeft
        let topLeftCenterY = minY + cornerRadii.topLeft

        let topRightCenterX = maxX - cornerRadii.topRight
        let topRightCenterY = minY + cornerRadii.topRight

        let bottomLeftCenterX = minX + cornerRadii.bottomLeft
        let bottomLeftCenterY = maxY - cornerRadii.bottomLeft

        let bottomRightCenterX = maxX - cornerRadii.bottomRight
        let bottomRightCenterY = maxY - cornerRadii.bottomRight

        // 虽然顺时针参数是YES，在iOS中的UIView中，这里实际是逆时针
        let path = CGMutablePath()
        // 顶 左
        path.addArc(center: CGPoint(x: topLeftCenterX, y: topLeftCenterY), radius: cornerRadii.topLeft, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 3 / 2, clockwise: false)
        // 顶右
        path.addArc(center: CGPoint(x: topRightCenterX, y: topRightCenterY), radius: cornerRadii.topRight, startAngle: CGFloat.pi * 3 / 2, endAngle: 0, clockwise: false)
        // 底右
        path.addArc(center: CGPoint(x: bottomRightCenterX, y: bottomRightCenterY), radius: cornerRadii.bottomRight, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: false)
        // 底左
        path.addArc(center: CGPoint(x: bottomLeftCenterX, y: bottomLeftCenterY), radius: cornerRadii.bottomLeft, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: false)
        path.closeSubpath()
        return path
    }
}

extension UIView {
    /// 转为Image
    /// - Returns: UIImage
    public func toImage() -> UIImage? {
        let size = bounds.size
        // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - 边框功能

extension UIView {
    // 画线
    private func drawBorder(rect: CGRect, color: UIColor) {
        let line = UIBezierPath(rect: rect)
        let lineShape = CAShapeLayer()
        lineShape.path = line.cgPath
        lineShape.fillColor = color.cgColor
        layer.addSublayer(lineShape)
    }

    // 设置右边框
    public func rightBorder(width: CGFloat, borderColor: UIColor) {
        let rect = CGRect(x: 0, y: frame.size.width - width, width: width, height: frame.size.height)
        drawBorder(rect: rect, color: borderColor)
    }

    // 设置左边框
    public func leftBorder(width: CGFloat, borderColor: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
        drawBorder(rect: rect, color: borderColor)
    }

    // 设置上边框
    public func topBorder(width: CGFloat, borderColor: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        drawBorder(rect: rect, color: borderColor)
    }

    // 设置底边框
    public func buttomBorder(width: CGFloat, borderColor: UIColor) {
        let rect = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        drawBorder(rect: rect, color: borderColor)
    }
}

// MARK: - 渐变相关

extension UIView {
    /// 为View添加渐变图层
    /// - Parameters:
    ///   - startPoint: 起始点
    ///   - endPoint: 终止点
    ///   - colors: 渐变色数组
    public func gradientColor(startPoint: CGPoint, endPoint: CGPoint, colors: [UIColor], height: CGFloat? = nil) {
        guard startPoint.x >= 0, startPoint.x <= 1, startPoint.y >= 0, startPoint.y <= 1, endPoint.x >= 0, endPoint.x <= 1, endPoint.y >= 0, endPoint.y <= 1 else {
            return
        }

        removeGradientLayer()

        layoutIfNeeded()
        superview?.layoutIfNeeded()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = layer.bounds
        if let height = height {
            gradientLayer.frame = CGRect(x: gradientLayer.frame.origin.x, y: gradientLayer.frame.origin.y, width: gradientLayer.frame.width, height: height)
        }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors.compactMap { $0.cgColor }
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.masksToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = false
    }

    /// 移除渐变图层
    public func removeGradientLayer() {
        if let sl = layer.sublayers {
            for layer in sl {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
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
            gestureDict = [gestureKey: gesture]
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
    private func tapGestureAction(_ tap: UITapGestureRecognizer) {
        executeGestureAction(.tapGesture, gesture: tap)
    }

    @objc
    private func pinchGestureAction(_ pinch: UIPinchGestureRecognizer) {
        executeGestureAction(.pinchGesture, gesture: pinch)
    }

    @objc
    private func rotationGestureAction(_ rotation: UIRotationGestureRecognizer) {
        executeGestureAction(.rotationGesture, gesture: rotation)
    }

    @objc
    private func swipeGestureAction(_ swipe: UISwipeGestureRecognizer) {
        executeGestureAction(.swipeGesture, gesture: swipe)
    }

    @objc
    private func panGestureAction(_ pan: UIPanGestureRecognizer) {
        executeGestureAction(.panGesture, gesture: pan)
    }

    @objc
    private func longPressGestureAction(_ longPress: UILongPressGestureRecognizer) {
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

    /// 扩大点击区域
    /// 此方法只对UIView的子类起作用，子类需要重写hitTest方法
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
        if !isUserInteractionEnabled || alpha <= 0.01 || isHidden {
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
        if !isUserInteractionEnabled || alpha <= 0.01 || isHidden {
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

// MARK: - 增大UIButton点击热区

/// 不可以直接使用UIControl，无效

extension UIButton {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !isUserInteractionEnabled || alpha <= 0.01 || isHidden || !isEnabled {
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

// MARK: - 未使用命名空间

// MARK: - IB支持配置动态属性

extension UIView {
    /// 圆角
    @IBInspectable
    public var csCornerRadius: CGFloat {
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
    public var csBorderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    /// 边框颜色
    @IBInspectable
    public var csBorderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
    }

    /// 加载 xib view 类方法
    @objc
    public class func initByNib(bundle: Bundle = Bundle.main) -> Self? {
        guard let view = bundle.loadNibNamed(String(describing: Self.self), owner: nil, options: [:])?.last as? Self else {
            assertionFailure("Failed to load a view with nibName \(String(describing: Self.self)) Check that the nibName of your XIB/Storyboard")
            return nil
        }
        return view
    }
}
