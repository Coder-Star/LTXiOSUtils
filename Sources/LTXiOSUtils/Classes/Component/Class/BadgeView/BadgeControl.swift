//
//  BadgeControl.swift
//  NCAppUIiOS
//
//  Created by CoderStar on 2020/1/12.
//

import UIKit

/// 角标伸缩模式
public enum BadgeViewFlexMode {
    /// 左伸缩    : <==●
    case head
    /// 右伸缩    : ●==>
    case tail
    /// 左右伸缩  : <=●=>
    case middle
}

public class BadgeControl: UIControl {
    /// 记录Badge的偏移量
    public var offset = CGPoint(x: 0, y: 0)

    /// Badge伸缩的方向
    public var flexMode: BadgeViewFlexMode = .tail

    /// 左右内边距
    public var sidePadding: (leading: CGFloat, trailing: CGFloat) = (5, -5) {
        didSet {
            addLayout(with: textLabel, leading: sidePadding.leading, trailing: sidePadding.trailing)
        }
    }

    /// 文字
    public var text: String? {
        didSet {
            textLabel.text = text
        }
    }

    /// 字体大小
    public var font: UIFont? {
        didSet {
            textLabel.font = font
        }
    }

    /// 富文本
    public var attributedText: NSAttributedString? {
        didSet {
            textLabel.attributedText = attributedText
        }
    }

    /// 设置背景图片，优先级比 backgroundColor 高
    /// 当设置为nil时，会显示成之前设置的背景色
    public var backgroundImage: UIImage? {
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

    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 10)
        textLabel.textAlignment = .center
        return textLabel
    }()

    private lazy var imageView = UIImageView()

    /// 记录之前设置的背景色
    private var badgeViewColor: UIColor?

    /// 记录之前的宽度约束
    private var badgeViewHeightConstraint: NSLayoutConstraint?

    required override public init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    open override var backgroundColor: UIColor? {
        didSet {
            super.backgroundColor = backgroundColor
            badgeViewColor = backgroundColor
        }
    }
}

extension BadgeControl {
    private func setupSubviews() {
        layer.masksToBounds = true
        backgroundColor = .red
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(textLabel)
        addSubview(imageView)

        addLayout(with: imageView, leading: 0, trailing: 0)
        addLayout(with: textLabel, leading: sidePadding.leading, trailing: sidePadding.trailing)
    }

    private func addLayout(with view: UIView, leading: CGFloat, trailing: CGFloat) {
        view.removeConstraints(view.constraints)

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
