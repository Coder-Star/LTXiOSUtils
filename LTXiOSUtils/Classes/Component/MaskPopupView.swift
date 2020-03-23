//
//  MaskPopupView.swift
//  LTXiOSUtils
//  便利的蒙板弹出view
//  Created by 李天星 on 2019/11/21.
//

import Foundation
import UIKit

public protocol MaskPopupViewAnimationProtocol: AnyObject {
    /// 初始化配置动画驱动器
    ///
    /// - Parameters:
    ///   - contentView: 自定义的弹框视图
    ///   - backgroundView: 背景视图
    ///   - containerView: 展示弹框的视图
    /// - Returns: void
    func setup(contentView: UIView, backgroundView: MaskBackgroundView, containerView: UIView)

    /// 处理展示动画
    ///
    /// - Parameters:
    ///   - contentView: 自定义的弹框视图
    ///   - backgroundView: 背景视图
    ///   - animated: 是否需要动画
    ///   - completion: 动画完成后的回调
    /// - Returns: void
    func display(contentView: UIView, backgroundView: MaskBackgroundView, animated: Bool, completion: @escaping () -> Void)

    /// 处理消失动画
    ///
    /// - Parameters:
    ///   - contentView: 自定义的弹框视图
    ///   - backgroundView: 背景视图
    ///   - animated: 是否需要动画
    ///   - completion: 动画完成后的回调
    func dismiss(contentView: UIView, backgroundView: MaskBackgroundView, animated: Bool, completion: @escaping () -> Void)
}

/// 蒙板类型
public enum MaskPopupViewBackgroundStyle {
    /// - solidColor: 纯色
    case solidColor
    /// - blur: 毛玻璃
    case blur
}

/// 一个轻量级的自定义视图弹框框架，主要提供动画、背景的灵活配置，功能简单却强大
/// 通过面对协议MaskPopupViewAnimationProtocol，实现对动画的灵活配置
/// 通过MaskBackgroundView对背景进行自定义配置
public class MaskPopupView: UIView {
    /*
     举个例子
     /////////////////////
     ///////////////////B/
     ////-------------////
     ///|             |///
     ///|             |///
     ///|             |///
     ///|             |///
     ///|             |///
     ///|      A      |///
     ///|             |///
     ///|             |///
     ///|             |///
     ///|_____________|///
     /////////////////////
     /////////////////////
     
     - isDismissible  为YES时，点击区域B可以消失（前提是isPenetrable为false）
     - isInteractive  为YES时，点击区域A可以触发contentView上的交互操作
     - isPenetrable   为YES时，将会忽略区域B的交互操作
     */
    public var isDismissible = false {
        didSet {
            backgroundView.isUserInteractionEnabled = isDismissible
        }
    }
    public var isInteractive = true
    public var isPenetrable = false
    public let backgroundView: MaskBackgroundView
    public var willDispalyCallback: (() -> Void)?
    public var didDispalyCallback: (() -> Void)?
    public var willDismissCallback: (() -> Void)?
    public var didDismissCallback: (() -> Void)?

    weak var containerView: UIView!
    let contentView: UIView
    let animator: MaskPopupViewAnimationProtocol
    var isAnimating = false

    deinit {
        willDispalyCallback = nil
        didDispalyCallback = nil
        willDismissCallback = nil
        didDismissCallback = nil
    }

    /// 指定的初始化器
    /// 需要注意的是需要指定contentView的frame，动画需要
    /// - Parameters:
    ///   - containerView: 展示弹框的视图，可以是window、vc.view、自定义视图等
    ///   - contentView: 自定义的弹框视图
    ///   - animator: 遵从协议MaskPopupViewAnimationProtocol的动画驱动器
    public init(containerView: UIView, contentView: UIView, animator: MaskPopupViewAnimationProtocol) {
        self.containerView = containerView
        self.contentView = contentView
        self.animator = animator
        backgroundView = MaskBackgroundView(frame: CGRect.zero)

        super.init(frame: containerView.bounds)

        backgroundView.isUserInteractionEnabled = isDismissible
        backgroundView.addTarget(self, action: #selector(backgroundViewClicked), for: UIControl.Event.touchUpInside)
        addSubview(backgroundView)
        addSubview(contentView)

        animator.setup(contentView: contentView, backgroundView: backgroundView, containerView: containerView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let pointInContent = convert(point, to: contentView)
        let isPointInContent = contentView.bounds.contains(pointInContent)
        if isPointInContent {
            if isInteractive {
                return super.hitTest(point, with: event)
            } else {
                return nil
            }
        } else {
            if !isPenetrable {
                return super.hitTest(point, with: event)
            } else {
                return nil
            }
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        backgroundView.frame = self.bounds
    }

    public func display(animated: Bool, completion: (() -> Void)?) {
        if isAnimating {
            return
        }
        isAnimating = true
        containerView.addSubview(self)

        willDispalyCallback?()
        animator.display(contentView: contentView, backgroundView: backgroundView, animated: animated) {
            completion?()
            self.isAnimating = false
            self.didDispalyCallback?()
        }
    }

    public func dismiss(animated: Bool, completion: (() -> Void)?) {
        if isAnimating {
            return
        }
        isAnimating = true
        willDismissCallback?()
        animator.dismiss(contentView: contentView, backgroundView: backgroundView, animated: animated) {
            self.removeFromSuperview()
            completion?()
            self.isAnimating = false
            self.didDismissCallback?()
        }
    }

    @objc
    func backgroundViewClicked() {
        dismiss(animated: true, completion: nil)
    }
}

/// 扩展
public extension UIView {

    /// 便利获取MaskPopupView
    var maskPopupView: MaskPopupView? {
        if self.superview?.isKind(of: MaskPopupView.classForCoder()) == true {
            return self.superview as? MaskPopupView
        }
        return nil
    }
}

public class MaskBackgroundView: UIControl {
    public var style = MaskPopupViewBackgroundStyle.solidColor {
        didSet {
            refreshBackgroundStyle()
        }
    }
    public var blurEffectStyle = UIBlurEffect.Style.dark {
        didSet {
            refreshBackgroundStyle()
        }
    }
    /// 无论style是什么值，color都会生效。如果你使用blur的时候，觉得叠加上该color过于黑暗时，可以置为clearColor。
    public var color = UIColor.black.withAlphaComponent(0.3) {
        didSet {
            backgroundColor = color
        }
    }
    var effectView: UIVisualEffectView? //毛玻璃效果

    public override init(frame: CGRect) {
        super.init(frame: frame)

        refreshBackgroundStyle()
        backgroundColor = color
        layer.allowsGroupOpacity = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == effectView {
            //将event交给backgroundView处理
            return self
        }
        return view
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        effectView?.frame = self.bounds
    }

    func refreshBackgroundStyle() {
        if style == .solidColor {
            effectView?.removeFromSuperview()
            effectView = nil
        } else {
            effectView = UIVisualEffectView(effect: UIBlurEffect(style: self.blurEffectStyle))
            addSubview(effectView!)
        }
    }
}

open class MaskPopupViewBaseAnimator: MaskPopupViewAnimationProtocol {
    open var displayDuration: TimeInterval = 0.25
    open var displayAnimationOptions = UIView.AnimationOptions.init(rawValue: UIView.AnimationOptions.beginFromCurrentState.rawValue & UIView.AnimationOptions.curveEaseInOut.rawValue)
    /// 展示动画的配置block
    open var displayAnimateBlock: (() -> Void)?

    open var dismissDuration: TimeInterval = 0.25
    open var dismissAnimationOptions = UIView.AnimationOptions.init(rawValue: UIView.AnimationOptions.beginFromCurrentState.rawValue & UIView.AnimationOptions.curveEaseInOut.rawValue)
    /// 消失动画的配置block
    open var dismissAnimateBlock: (() -> Void)?

    public init() {
    }

    open func setup(contentView: UIView, backgroundView: MaskBackgroundView, containerView: UIView) {
    }

    open func display(contentView: UIView, backgroundView: MaskBackgroundView, animated: Bool, completion: @escaping () -> Void) {
        if animated {
            UIView.animate(withDuration: displayDuration, delay: 0, options: displayAnimationOptions, animations: {
                self.displayAnimateBlock?()
            }, completion: { _ in
                completion()
            })
        } else {
            self.displayAnimateBlock?()
            completion()
        }
    }

    open func dismiss(contentView: UIView, backgroundView: MaskBackgroundView, animated: Bool, completion: @escaping () -> Void) {
        if animated {
            UIView.animate(withDuration: dismissDuration, delay: 0, options: dismissAnimationOptions, animations: {
                self.dismissAnimateBlock?()
            }, completion: { _ in
                completion()
            })
        } else {
            self.dismissAnimateBlock?()
            completion()
        }
    }
}

/// 往左
open class MaskPopupViewLeftwardAnimator: MaskPopupViewBaseAnimator {
    open override func setup(contentView: UIView, backgroundView: MaskBackgroundView, containerView: UIView) {
        var frame = contentView.frame
        frame.origin.x = containerView.bounds.size.width
        let sourceRect = frame
        let targetRect = contentView.frame
        contentView.frame = sourceRect
        backgroundView.alpha = 0

        displayAnimateBlock = {
            contentView.frame = targetRect
            backgroundView.alpha = 1
        }
        dismissAnimateBlock = {
            contentView.frame = sourceRect
            backgroundView.alpha = 0
        }
    }
}

/// 往右
open class MaskPopupViewRightwardAnimator: MaskPopupViewBaseAnimator {
    open override func setup(contentView: UIView, backgroundView: MaskBackgroundView, containerView: UIView) {
        var frame = contentView.frame
        frame.origin.x = -contentView.bounds.size.width
        let sourceRect = frame
        let targetRect = contentView.frame
        contentView.frame = sourceRect
        backgroundView.alpha = 0

        displayAnimateBlock = {
            contentView.frame = targetRect
            backgroundView.alpha = 1
        }
        dismissAnimateBlock = {
            contentView.frame = sourceRect
            backgroundView.alpha = 0
        }
    }
}

/// 往上
open class MaskPopupViewUpwardAnimator: MaskPopupViewBaseAnimator {
    open override func setup(contentView: UIView, backgroundView: MaskBackgroundView, containerView: UIView) {
        var frame = contentView.frame
        frame.origin.y = containerView.bounds.size.height
        let sourceRect = frame
        let targetRect = contentView.frame
        contentView.frame = sourceRect
        backgroundView.alpha = 0

        displayAnimateBlock = {
            contentView.frame = targetRect
            backgroundView.alpha = 1
        }
        dismissAnimateBlock = {
            contentView.frame = sourceRect
            backgroundView.alpha = 0
        }
    }
}
/// 往下
open class MaskPopupViewDownwardAnimator: MaskPopupViewBaseAnimator {
    open override func setup(contentView: UIView, backgroundView: MaskBackgroundView, containerView: UIView) {
        var frame = contentView.frame
        frame.origin.y = -contentView.bounds.size.height
        let sourceRect = frame
        let targetRect = contentView.frame
        contentView.frame = sourceRect
        backgroundView.alpha = 0

        displayAnimateBlock = {
            contentView.frame = targetRect
            backgroundView.alpha = 1
        }
        dismissAnimateBlock = {
            contentView.frame = sourceRect
            backgroundView.alpha = 0
        }
    }
}
/// 渐变
open class MaskPopupViewFadeInOutAnimator: MaskPopupViewBaseAnimator {
    open override func setup(contentView: UIView, backgroundView: MaskBackgroundView, containerView: UIView) {
        contentView.alpha = 0
        backgroundView.alpha = 0

        displayAnimateBlock = {
            contentView.alpha = 1
            backgroundView.alpha = 1
        }
        dismissAnimateBlock = {
            contentView.alpha = 0
            backgroundView.alpha = 0
        }
    }
}
/// 缩放
open class MaskPopupViewZoomInOutAnimator: MaskPopupViewBaseAnimator {
    open override func setup(contentView: UIView, backgroundView: MaskBackgroundView, containerView: UIView) {
        contentView.alpha = 0
        backgroundView.alpha = 0
        contentView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)

        displayAnimateBlock = {
            contentView.alpha = 1
            contentView.transform = .identity
            backgroundView.alpha = 1
        }
        dismissAnimateBlock = {
            contentView.alpha = 0
            contentView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            backgroundView.alpha = 0
        }
    }
}

/// 弹性动画
open class MaskPopupViewSpringDownwardAnimator: MaskPopupViewDownwardAnimator {

    open override func display(contentView: UIView, backgroundView: MaskBackgroundView, animated: Bool, completion: @escaping () -> Void) {
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: displayAnimationOptions, animations: {
                self.displayAnimateBlock?()
            }, completion: { _ in
                completion()
            })
        } else {
            self.displayAnimateBlock?()
            completion()
        }
    }
}
