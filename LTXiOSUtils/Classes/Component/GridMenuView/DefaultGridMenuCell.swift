//
//  DefaultGridMenuCell.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2020/1/12.
//

import Foundation

/// 角标显示样式
public enum CornerMarkType {
    /// 无
    case none
    /// 数字
    case number(number: Int)
    /// 红点
    case point(isShow: Bool)
    /// 文字
    case text(text: String)
}

open class DefaultGridMenuCell: UICollectionViewCell {
    /// 角标显示数字最大值，如果再比这个大，就显示99+的形式,为nil值不限制
    public static var maxNumber: Int? = 99
    /// 标题颜色
    public static var labelColor = UIColor.black.adapt()
    /// 标题字体
    public static var labelFont = UIFont.systemFont(ofSize: 14)

    public var imageView = UIImageView()

    public var text = "" {
        didSet {
            label.text = text
        }
    }
    public var font: UIFont = DefaultGridMenuCell.labelFont {
        didSet {
            label.font = font
        }
    }
    public var textColor: UIColor = DefaultGridMenuCell.labelColor {
        didSet {
            label.textColor = textColor
        }
    }
    public var markType: CornerMarkType = .number(number: 0) {
        didSet {
            setBadge()
        }
    }
    private lazy var label: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = font
        label.textColor = textColor
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let labelHeight = 20.cgFloatValue
        let imageHeight = frame.height - labelHeight - 20.cgFloatValue
        let imageWidth = imageHeight
        imageView.frame = CGRect(x: (frame.width - imageWidth)/2, y: 10, width: imageWidth, height: imageHeight)
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        self.addSubview(imageView)
        label.frame = CGRect(x: 5, y: imageHeight + 15, width: frame.width - 10.cgFloatValue, height: labelHeight)
        self.addSubview(label)
        self.core.setBadge(flexMode: .middle)
        self.core.moveBadge(x: -1 * imageView.frame.origin.x, y: imageView.frame.origin.y)
    }

    private func setBadge() {
        switch markType {
        case .none:
            self.core.hiddenBadge()
        case .number(let number):
            if let maxNumber = DefaultGridMenuCell.maxNumber, number > maxNumber {
                self.core.setBadge(height: 18)
                self.core.addBadge(text: "\(maxNumber)+")
            } else if number <= 0 {
                self.core.hiddenBadge()
            } else {
                self.core.setBadge(height: 18)
                self.core.addBadge(number: number)
            }
        case .point(let isShow):
            if isShow {
                self.core.addDot(color: .red)
                self.core.setBadge(height: 12)
            } else {
                self.core.hiddenBadge()
            }
        case .text(let text):
             self.core.setBadge(height: 18)
             self.core.addBadge(text: text)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
