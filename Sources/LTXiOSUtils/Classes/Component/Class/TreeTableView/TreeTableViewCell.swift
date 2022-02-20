//
//  TreeTableViewCell.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2020/2/1.
//

import Foundation

/// Cell文字显示样式
public enum TreeTableViewCellTextStyle {
    /// 全部显示
    case all
    /// 自适应字体
    case adjustFont
    /// 冒号显示，前面冒号
    case truncatingHead
    /// 冒号显示，后面冒号
    case truncatingTail
    /// 冒号显示，中间冒号
    case truncatingMiddle
}

public class TreeTableViewCell: UITableViewCell {
    /// 节点数据
    public var treeNode: TreeNode! {
        didSet {
            setCellView()
        }
    }

    /// 是否单选
    public var isSingleCheck: Bool = true {
        didSet {
            if treeNode != nil {
                accessoryView = getCheckButton(isSingleCheck: isSingleCheck)
            }
        }
    }

    /// 点击闭包
    public var checkClick: ((_ treeNode: TreeNode) -> Void)?

    /// Cell文字显示样式
    public var cellTextStyle: TreeTableViewCellTextStyle = .truncatingTail {
        didSet {
            switch cellTextStyle {
            case .all:
                textLabel?.numberOfLines = 0
                textLabel?.lineBreakMode = .byCharWrapping
            case .adjustFont:
                textLabel?.numberOfLines = 1
                textLabel?.adjustsFontSizeToFitWidth = true
            case .truncatingHead:
                textLabel?.numberOfLines = 1
                textLabel?.lineBreakMode = .byTruncatingHead
            case .truncatingTail:
                textLabel?.numberOfLines = 1
                textLabel?.lineBreakMode = .byTruncatingTail
            case .truncatingMiddle:
                textLabel?.numberOfLines = 1
                textLabel?.lineBreakMode = .byTruncatingMiddle
            }
        }
    }

    /// 左边间距
    private let leftMargin: CGFloat = 15
    /// 字体大小
    private let fontSize: CGFloat = 15

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let minX = leftMargin + indentationLevel.tx.cgFloatValue * indentationWidth
        var imageViewFrame = imageView?.frame
        imageViewFrame?.origin.x = minX
        imageView?.frame = imageViewFrame!
        var textLabelFrame = textLabel?.frame
        textLabelFrame?.origin.x = minX + max(imageView!.bounds.size.width, leftMargin) + 2
        let textLabelX = textLabelFrame?.origin.x
        textLabelFrame?.size.width = (accessoryView?.frame.origin.x)! - textLabelX! - 5
        textLabel?.frame = textLabelFrame!
    }

    private func setupView() {
        textLabel?.font = UIFont.systemFont(ofSize: fontSize)
        selectionStyle = .none
        indentationWidth = leftMargin
    }
}

// MARK: - 公开属性

extension TreeTableViewCell {
    /// 刷新箭头
    public func refreshArrow() {
        UIView.animate(withDuration: 0.25) {
            self.updateArrow()
        }
    }
}

// MARK: - 私有方法

extension TreeTableViewCell {
    private func setCellView() {
        indentationLevel = treeNode.level
        textLabel?.text = treeNode.name
        if treeNode.childNodes.count > 0 {
            imageView?.image = "TreeTableView_arrow".imageOfLTXiOSUtilsComponent
        } else {
            imageView?.image = nil
        }
        accessoryView = getCheckButton(isSingleCheck: isSingleCheck)
        updateArrow()
    }

    private func getCheckImage() -> UIImage? {
        switch treeNode.checkState {
        case .uncheckd:
            return "TreeTableView_checkbox_uncheck".imageOfLTXiOSUtilsComponent
        case .checked:
            return "TreeTableView_checkbox_checked".imageOfLTXiOSUtilsComponent
        case .halfChecked:
            return "TreeTableView_checkbox_halfchecked".imageOfLTXiOSUtilsComponent
        }
    }

    private func getCheckButton(isSingleCheck: Bool) -> UIButton {
        let button = UIButton(type: .custom)
        button.addTouchUpInsideAction { _ in
            self.checkClick?(self.treeNode)
        }
        button.adjustsImageWhenHighlighted = false
        if isSingleCheck {
            let buttonWidth: CGFloat = 50
            let buttonHeight: CGFloat = 25
            button.frame = CGRect(x: 0, y: (contentView.bounds.size.height - buttonHeight) / 2, width: buttonWidth, height: buttonHeight)
            button.setTitle("选择", for: .normal)
            button.backgroundColor = .white
            button.setTitleColor(.blue, for: .normal)
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.cornerRadius = 5
            button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            button.layer.borderWidth = 0.5
        } else {
            button.frame = CGRect(x: 0, y: 0, width: contentView.bounds.size.height, height: contentView.bounds.size.height)
            let checkImage = getCheckImage()
            button.setImage(checkImage, for: .normal)
            let margin = (button.frame.height - button.imageView!.frame.height) / 2
            button.contentEdgeInsets = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        }
        return button
    }

    /// 更新cell前面箭头
    private func updateArrow() {
        if treeNode.isExpand {
            imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        } else {
            imageView?.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
}
