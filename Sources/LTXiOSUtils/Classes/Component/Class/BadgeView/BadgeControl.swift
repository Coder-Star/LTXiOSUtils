//
//  BadgeControl.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2020/1/12.
//

// 示例Demo
// view = UIView, UITabBarItem, UIBarButtonItem及其子类
// view.core.addBadge(text: text)

import UIKit

/// 角标伸缩模式
public enum BadgeViewFlexMode {
    /// 左伸缩 Head Flex    : <==●
    case head
    /// 右伸缩 Tail Flex    : ●==>
    case tail
    /// 左右伸缩 Middle Flex : <=●=>
    case middle
}

open class BadgeControl: UIControl {
    /// 记录Badge的偏移量 Record the offset of Badge
    public var offset = CGPoint(x: 0, y: 0)

    /// Badge伸缩的方向, Default is BadgeViewFlexModeTail
    public var flexMode: BadgeViewFlexMode = .tail

    private lazy var textLabel = UILabel()

    private lazy var imageView = UIImageView()

    private var badgeViewColor: UIColor?
    private var badgeViewHeightConstraint: NSLayoutConstraint?

    public class func `default`() -> Self {
        return self.init(frame: .zero)
    }

    required override public init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    /// Set Text
    open var text: String? {
        didSet {
            textLabel.text = text
        }
    }

    /// Set AttributedText
    open var attributedText: NSAttributedString? {
        didSet {
            textLabel.attributedText = attributedText
        }
    }

    /// Set Font
    open var font: UIFont? {
        didSet {
            textLabel.font = font
        }
    }

    /// Set background image
    open var backgroundImage: UIImage? {
        didSet {
            imageView.image = backgroundImage
            if backgroundImage != nil {
                if let constraint = heightConstraint() {
                    badgeViewHeightConstraint = constraint
                    removeConstraint(constraint)
                }
                backgroundColor = UIColor.clear
            } else {
                if heightConstraint() == nil, let constraint = badgeViewHeightConstraint {
                    addConstraint(constraint)
                }
                backgroundColor = badgeViewColor
            }
        }
    }

    open override var backgroundColor: UIColor? {
        didSet {
            super.backgroundColor = backgroundColor
            if let color = backgroundColor, color != .clear {
                badgeViewColor = backgroundColor
            }
        }
    }

    private func setupSubviews() {
        layer.masksToBounds = true
        layer.cornerRadius = 9.0
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.red
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textAlignment = .center
        addSubview(textLabel)
        addSubview(imageView)
        addLayout(with: imageView, leading: 0, trailing: 0)
        addLayout(with: textLabel, leading: 5, trailing: -5)
    }

    private func addLayout(with view: UIView, leading: CGFloat, trailing: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: leading)
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: trailing)
        leadingConstraint.priority = UILayoutPriority(rawValue: 999)
        trailingConstraint.priority = UILayoutPriority(rawValue: 999)
        addConstraints([topConstraint, leadingConstraint, bottomConstraint, trailingConstraint])
    }
}
