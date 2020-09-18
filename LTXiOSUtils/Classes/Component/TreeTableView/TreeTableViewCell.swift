//
//  TreeTableViewCell.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2020/2/1.
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
                self.accessoryView = getCheckButton(isSingleCheck: isSingleCheck)
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
        let minX = leftMargin + self.indentationLevel.tx.cgFloatValue * self.indentationWidth
        var imageViewFrame = imageView?.frame
        imageViewFrame?.origin.x = minX
        self.imageView?.frame = imageViewFrame!
        var textLabelFrame = textLabel?.frame
        textLabelFrame?.origin.x = minX + max(self.imageView!.bounds.size.width, leftMargin) + 2
        let textLabelX = textLabelFrame?.origin.x
        textLabelFrame?.size.width = (accessoryView?.frame.origin.x)! - textLabelX! - 5
        self.textLabel?.frame = textLabelFrame!
    }

    private func setupView() {
        self.textLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.selectionStyle = .none
        self.indentationWidth = leftMargin
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
        self.indentationLevel = self.treeNode.level
        self.textLabel?.text = self.treeNode.name
        if treeNode.childNodes.count > 0 {
            self.imageView?.image = "TreeTableView_arrow".imageOfLTXiOSUtils()
        } else {
            self.imageView?.image = nil
        }
        self.accessoryView = getCheckButton(isSingleCheck: isSingleCheck)
        updateArrow()
    }

    private func getCheckImage() -> UIImage? {
        switch treeNode.checkState {
        case .uncheckd:
            return "TreeTableView_checkbox_uncheck".imageOfLTXiOSUtils()
        case .checked:
            return "TreeTableView_checkbox_checked".imageOfLTXiOSUtils()
        case .halfChecked:
            return "TreeTableView_checkbox_halfchecked".imageOfLTXiOSUtils()
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
            button.frame = CGRect(x: 0, y: (self.contentView.bounds.size.height - buttonHeight) / 2, width: buttonWidth, height: buttonHeight)
            button.setTitle("选择", for: .normal)
            button.backgroundColor = .white
            button.setTitleColor(.blue, for: .normal)
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.cornerRadius = 5
            button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            button.layer.borderWidth = 0.5
        } else {
            button.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.size.height, height: self.contentView.bounds.size.height)
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
            self.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        } else {
            self.imageView?.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
}
