//
//  MaskPopupView.swift
//  LTXiOSUtils
//  便利的蒙板弹出view
//  Created by CoderStar on 2019/11/21.
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

    /// 是否点击蒙版空白处关闭弹框
    public var isDismissible = true {
        didSet {
            backgroundView.isUserInteractionEnabled = isDismissible
        }
    }

    /// 内容view是否可以进行交互
    public var isInteractive = true
    /// 蒙版View是否忽略交互操作
    public var isPenetrable = false
    /// 蒙版View
    public let backgroundView: MaskBackgroundView
    /// 蒙版即将出现闭包
    public var willDispalyCallback: (() -> Void)?
    /// 蒙版已经出现闭包
    public var didDispalyCallback: (() -> Void)?
    /// 蒙版即将消失闭包
    public var willDismissCallback: (() -> Void)?
    /// 蒙版已经消失闭包
    public var didDismissCallback: (() -> Void)?

    /// 当containerView为UIScrollview时，是否自定义尺寸
    public var isAdaptSize = true

    private weak var containerView: UIView!
    private var contentView: UIView
    private let animator: MaskPopupViewAnimationProtocol
    private var isAnimating = false

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

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let pointInContent = convert(point, to: contentView)
        // 是否位于内容View里
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

        backgroundView.frame = bounds
    }

    /// 蒙版显示
    /// - Parameters:
    ///   - animated: 是否显示动画
    ///   - completion: 显示完成
    public func display(animated: Bool, completion: (() -> Void)?) {
        if isAnimating {
            return
        }
        isAnimating = true
        containerView.addSubview(self)

        if let contentScrollView = contentView as? UIScrollView, isAdaptSize {
            containerView.layoutIfNeeded()
            contentView.tx.height = contentScrollView.contentSize.height
        }
        willDispalyCallback?()
        animator.display(contentView: contentView, backgroundView: backgroundView, animated: animated) {
            completion?()
            self.isAnimating = false
            self.didDispalyCallback?()
        }
    }

    /// 蒙版消失
    /// - Parameters:
    ///   - animated: 是否显示动画
    ///   - completion: 消失完成
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
extension UIView {
    /// 获取view父View中的MaskPopupView
    public var maskPopupView: MaskPopupView? {
        if superview?.isKind(of: MaskPopupView.classForCoder()) == true {
            return superview as? MaskPopupView
        }
        return nil
    }
}

public class MaskBackgroundView: UIControl {
    /// 蒙版样式
    public var style = MaskPopupViewBackgroundStyle.solidColor {
        didSet {
            refreshBackgroundStyle()
        }
    }

    /// 蒙版样式为毛玻璃时，毛玻璃样式
    public var blurEffectStyle = UIBlurEffect.Style.dark {
        didSet {
            refreshBackgroundStyle()
        }
    }

    /// 蒙版颜色
    public var color = UIColor.black.withAlphaComponent(0.3) {
        didSet {
            backgroundColor = color
        }
    }

    private var effectView: UIVisualEffectView? // 毛玻璃效果

    public override init(frame: CGRect) {
        super.init(frame: frame)

        refreshBackgroundStyle()
        backgroundColor = color
        layer.allowsGroupOpacity = false
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == effectView {
            // 将毛玻璃的点击事件转为蒙版处理
            return self
        }
        return view
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        effectView?.frame = bounds
    }

    func refreshBackgroundStyle() {
        if style == .solidColor {
            effectView?.removeFromSuperview()
            effectView = nil
        } else {
            effectView = UIVisualEffectView(effect: UIBlurEffect(style: blurEffectStyle))
            addSubview(effectView!)
        }
    }
}

/// 基础动画效果类
open class MaskPopupViewBaseAnimator: MaskPopupViewAnimationProtocol {
    open var displayDuration: TimeInterval = 0.25
    open var displayAnimationOptions = UIView.AnimationOptions(rawValue: UIView.AnimationOptions.beginFromCurrentState.rawValue & UIView.AnimationOptions.curveEaseInOut.rawValue)
    /// 展示动画的配置block
    open var displayAnimateBlock: (() -> Void)?

    open var dismissDuration: TimeInterval = 0.25
    open var dismissAnimationOptions = UIView.AnimationOptions(rawValue: UIView.AnimationOptions.beginFromCurrentState.rawValue & UIView.AnimationOptions.curveEaseInOut.rawValue)
    /// 消失动画的配置block
    open var dismissAnimateBlock: (() -> Void)?

    public init() {}

    // 子类通过重写该方法实现不同动画效果，主要是设置显示闭包以及消失闭包
    open func setup(contentView: UIView, backgroundView: MaskBackgroundView, containerView: UIView) {}

    open func display(contentView: UIView, backgroundView: MaskBackgroundView, animated: Bool, completion: @escaping () -> Void) {
        if animated {
            UIView.animate(withDuration: displayDuration, delay: 0, options: displayAnimationOptions, animations: {
                self.displayAnimateBlock?()
            }, completion: { _ in
                completion()
            })
        } else {
            displayAnimateBlock?()
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
            dismissAnimateBlock?()
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
            displayAnimateBlock?()
            completion()
        }
    }
}
