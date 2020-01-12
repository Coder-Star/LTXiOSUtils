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
            setBadgeView()
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
        let imageWidth = frame.width - 30
        let imageHeight = imageWidth
        imageView.frame = CGRect(x: 5, y: 5, width: imageWidth, height: imageHeight)
        imageView.layer.cornerRadius = 10
        self.addSubview(imageView)
        label.frame = CGRect(x: 5, y: imageHeight + 10, width: imageWidth, height: 20)
        self.addSubview(label)
    }

    private func setBadgeView() {
        switch markType {
        case .none:
            if let view = badgeView {
                view.removeFromSuperview()
            }
        default:
            if badgeView == nil {
                badgeView = JSBadgeView(parentView: imageView, alignment: .topRight)
                badgeView?.badgePositionAdjustment = CGPoint(x: -5, y: 5)
                badgeView?.badgeBackgroundColor = .red
                badgeView?.badgeTextColor = .white
                imageView.addSubview(badgeView!)
            }
        }
    }

    private func setBadge() {
        switch markType {
        case .none:
            badgeView?.badgeText = ""
        case .number(let number):
            if number > 99 {
                badgeView?.badgeText = "99+"
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
