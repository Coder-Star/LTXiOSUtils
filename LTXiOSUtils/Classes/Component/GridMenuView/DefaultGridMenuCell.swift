//
//  DefaultGridMenuCell.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2020/1/12.
//

import Foundation
import JSBadgeView

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
    static let reuseID = "DefaultGridMenuCell"
    /// 角标显示数字最大值，如果再比这个大，就显示99+的形式,为nil值不限制
    public static let maxNumber:Int? = 99
    public var imageView: UIImageView = UIImageView()
    public var text = "" {
        didSet {
            label.text = text
        }
    }
    public var font: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            label.font = font
        }
    }
    public var textColor: UIColor = .black {
        didSet {
            label.textColor = textColor
        }
    }
    public var markType: CornerMarkType = .number(number: 0) {
        didSet {
            setBadge()
        }
    }
    private var badgeView: JSBadgeView?
    private lazy var label: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = font
        label.textColor = textColor
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame:frame)
        let labelHeight = 20.cgFloatValue
        let imageHeight = frame.height - labelHeight - 20.cgFloatValue
        let imageWidth = imageHeight
        imageView.frame = CGRect(x: (frame.width - imageWidth)/2, y: 10, width: imageWidth, height: imageHeight)
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        self.addSubview(imageView)
        label.frame = CGRect(x: 5, y: imageHeight + 15, width: frame.width - 10.cgFloatValue, height: labelHeight)
        self.addSubview(label)

        badgeView = JSBadgeView(parentView: self, alignment: .topRight)
        badgeView?.badgePositionAdjustment = CGPoint(x: -25, y: 15)
        badgeView?.badgeBackgroundColor = .red
        badgeView?.badgeTextColor = .white
    }

    private func setBadge() {
        switch markType {
        case .none:
            badgeView?.badgeText = ""
        case .number(let number):
            if let maxNumber = DefaultGridMenuCell.maxNumber , number > maxNumber {
                badgeView?.badgeText = "\(maxNumber)+"
            } else if number <= 0 {
                badgeView?.badgeText = ""
            } else {
                badgeView?.badgeText = "\(number)"
            }
        case .point(let isShow):
            if isShow {
                badgeView?.badgeText = " "
            } else {
                badgeView?.badgeText = ""
            }
        case .text(let text):
            badgeView?.badgeText = text
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
