//
//  SpinnerButton.swift
//  LTXiOSUtils
//  旋转按钮，表示加载状态
//  Created by 李天星 on 2020/1/1.
//

import UIKit

/// 动画类型
public enum AnimationType {

    /// 加载状态
    case collapse
    /// 加载状态之后返回到默认状态
    case expand
    /// 按钮抖动
    case shake
}

extension CAGradientLayer {
    convenience init(frame: CGRect) {
        self.init()
        self.frame = frame
    }
}

@IBDesignable
open class EMSpinnerButton: UIButton {

    // MARK: - 公开属性
    /// 圆角
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        willSet {
            layer.cornerRadius = newValue
        }
    }

    /// 状态之间转换的动画时间
    @IBInspectable public var animationDuration: Double = 0.2

    /// 颜色
    public var spinnerColor: CGColor? {
        willSet {
            spinner.color = newValue
        }
    }

    /// 渐变颜色
    public var gradientColors: [CGColor]? {
        willSet {
            gradientLayer.colors = newValue
        }
    }

    /// 按钮的标题
    public var title: String? {
        get {
            return self.title(for: .normal)
        }
        set {
            self.setTitle(newValue, for: .normal)
        }
    }

    /// 标题颜色
    public var titleColor: UIColor? {
        get {
            return self.titleColor(for: .normal)
        }
        set {
            self.setTitleColor(newValue, for: .normal)
        }
    }

    // MARK: - 私有属性
    private lazy var spinner: EMSpinnerLayer = {
         let spiner = EMSpinnerLayer(frame: self.frame)
         self.layer.addSublayer(spiner)
         return spiner
     }()

     private lazy var gradientLayer: CAGradientLayer = {
         let gradient = CAGradientLayer(frame: self.frame)
         gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
         gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
         layer.insertSublayer(gradient, at: 0)
         return gradient
     }()

    // MARK: - 初始化
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setUp()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    public init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setUp()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
        clipsToBounds = true
    }

    private func setUp() {
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.backgroundColor = UIColor(red: 49/255, green: 177/255, blue: 229/255, alpha: 1.0)
        self.titleColor = .white
    }
}

// MARK: - Public Methods
public extension EMSpinnerButton {
    /// 状态切换
    /// - Parameter animation: 动画样式
    func animate(animation: AnimationType) {
        switch animation {
        case .collapse:
            UIView.animate(withDuration: 0.1, animations: {
                self.layer.cornerRadius = self.frame.height/2
            }, completion: { _ in
                self.collapseAnimation()
            })
        case .expand:
            UIView.animate(withDuration: 0.1, animations: {
                self.layer.cornerRadius = self.cornerRadius
            }, completion: { _ in
                self.backToDefaults()
            })
        case .shake:
            shakeAnimation()
        }
    }
}

// MARK: - 动画相关方法
private extension EMSpinnerButton {

    /// 加载状态
    func collapseAnimation() {
        isUserInteractionEnabled = false
        let animaton = CABasicAnimation(keyPath: "bounds.size.width")
        animaton.fromValue = frame.width
        animaton.toValue =  frame.height
        animaton.duration = animationDuration
        animaton.fillMode = CAMediaTimingFillMode.forwards
        animaton.isRemovedOnCompletion = false
        layer.add(animaton, forKey: animaton.keyPath)
        spinner.isHidden = false
        spinner.startAnimation()
    }

    /// 返回到默认状态
    func backToDefaults() {
        spinner.stopAnimation()
        isUserInteractionEnabled = true
        let animaton = CABasicAnimation(keyPath: "bounds.size.width")
        animaton.fromValue = frame.height
        animaton.toValue = frame.width
        animaton.duration = animationDuration
        animaton.fillMode = CAMediaTimingFillMode.forwards
        animaton.isRemovedOnCompletion = false
        layer.add(animaton, forKey: animaton.keyPath)
        spinner.isHidden = true
    }

    /// 抖动状态
    func shakeAnimation() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
                let transform = CGAffineTransform(translationX: 10, y: 0)
                self.transform = transform
            })

            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.1, animations: {
                let transform = CGAffineTransform(translationX: -7, y: 0)
                self.transform = transform
            })

            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.1, animations: {
                let transform = CGAffineTransform(translationX: 5, y: 0)
                self.transform = transform
            })

            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.1, animations: {
                let transform = CGAffineTransform(translationX: -3, y: 0)
                self.transform = transform
            })

            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.1, animations: {
                let transform = CGAffineTransform(translationX: 2, y: 0)
                self.transform = transform
            })

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.1, animations: {
                let transform = CGAffineTransform(translationX: -1, y: 0)
                self.transform = transform
            })
        })
    }
}

// MARK: - EMSpinnerLayer
private class EMSpinnerLayer: CAShapeLayer {

    var color: CGColor? = UIColor.white.cgColor {
        willSet {
            strokeColor = newValue
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(frame: CGRect) {
        super.init()
        self.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
        let center = CGPoint(x: frame.height/2, y: frame.height/2)
        let circlePath = UIBezierPath(arcCenter: center, radius: 10, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        path = circlePath.cgPath
        lineWidth = 2.0
        strokeColor = color
        fillColor = UIColor.clear.cgColor
        self.isHidden = true
    }

    fileprivate func startAnimation() {
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -0.5
        strokeStartAnimation.toValue = 1.0

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1
        animationGroup.repeatCount = .infinity
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        add(animationGroup, forKey: nil)
    }

    fileprivate func stopAnimation() {
        removeAllAnimations()
    }
}
