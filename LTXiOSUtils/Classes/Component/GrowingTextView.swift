//
//  GrowingTextView.swift
//  LTXiOSUtils
//  高度自适应textView
//  Created by 李天星 on 2020/3/14.
//

import Foundation
import UIKit

open class GrowingTextView: UITextView {

    override open var text: String! {
        didSet { setNeedsDisplay() }
    }

    override open var attributedText: NSAttributedString! {
        didSet { setNeedsDisplay() }
    }

    /// 最小高度
    /// 设置为0表示没有限制
    /// 如果想设置高度，请使用这个属性，如果使用布局约束设定高度，则需要实现代理手动更新约束高度
    open var minHeight: CGFloat = 0 {
        didSet { forceLayoutSubviews() }
    }

    /// 最大高度
    /// 设置为0表示没有限制
    open var maxHeight: CGFloat = 0 {
        didSet { forceLayoutSubviews() }
    }

    /// 高度变化闭包
    open var heightChangeCallBack: ((_ height: CGFloat) -> Void)?

    private var heightConstraint: NSLayoutConstraint?
    private var oldText: String = ""
    private var oldSize: CGSize = .zero
    private var shouldScrollAfterHeightChanged = false

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        contentMode = .redraw
        associateConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: UITextView.textDidEndEditingNotification, object: self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 30)
    }

    private func associateConstraints() {
        for constraint in constraints where constraint.firstAttribute == .height && constraint.relation == .equal {
            heightConstraint = constraint
        }
    }

    private func forceLayoutSubviews() {
        oldSize = .zero
        setNeedsLayout()
        layoutIfNeeded()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        if text == oldText && bounds.size == oldSize { return }
        oldText = text
        oldSize = bounds.size

        let size = sizeThatFits(CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        var height = size.height

        height = minHeight > 0 ? max(height, minHeight) : height
        height = maxHeight > 0 ? min(height, maxHeight) : height

        if heightConstraint == nil {
            heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
            addConstraint(heightConstraint!)
        }

        if height != heightConstraint!.constant {
            shouldScrollAfterHeightChanged = true
            heightConstraint!.constant = height
            heightChangeCallBack?(height)
            setNeedsDisplay()
            self.superview?.layoutIfNeeded()
        } else if shouldScrollAfterHeightChanged {
            shouldScrollAfterHeightChanged = false
            scrollToCorrectPosition()
        }
    }

    private func scrollToCorrectPosition() {
        if self.isFirstResponder {
            /// 滚动到底部
            self.scrollRangeToVisible(NSRange(location: -1, length: 0))
        } else {
            /// 滚动到顶部
            self.scrollRangeToVisible(NSRange(location: 0, length: 0))
        }
    }

    @objc
    func textDidEndEditing(notification: Notification) {
        if let sender = notification.object as? GrowingTextView, sender == self {
            scrollToCorrectPosition()
        }
    }

    @objc
    func textDidChange(notification: Notification) {
        if let sender = notification.object as? GrowingTextView, sender == self {
            setNeedsDisplay()
            layoutIfNeeded()
        }
    }
}
