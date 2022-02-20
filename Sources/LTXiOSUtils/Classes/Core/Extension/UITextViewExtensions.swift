//
//  UITextViewExtensions.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2020/1/15.
//

import Foundation
import UIKit

extension TxExtensionWrapper where Base: UITextView {
    /// 取值时去除了空格符以及换行符
    /// 可用于提交表单前用来判断值是否不为空
    public var contentText: String? {
        set {
            base.text = newValue
        }
        get {
            return base.text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}

/**
 取消对UITextView的观察无法在扩展中进行，需要在业务中进行处理
 在iOS 9 (and OS X 10.11）之后，除了调用block-based api的需要手动调用removeObserver，其他不用再手动调用
 */

// MARK: - UITextView占位符以及最大字数等

extension UITextView {
    private static let observingKeys = [
        "attributedText",
        "text",
        "bounds",
    ]

    private struct RuntimeKey {
        static let placeholder = UnsafeRawPointer(bitPattern: "PLACEHOLDEL".hashValue)
        static let limitLength = UnsafeRawPointer(bitPattern: "LIMITLENGTH".hashValue)
        static let limitLines = UnsafeRawPointer(bitPattern: "LIMITLINES".hashValue)
        static let placeholderLabel = UnsafeRawPointer(bitPattern: "PLACEHOLDELABEL".hashValue)
        static let wordCountLabel = UnsafeRawPointer(bitPattern: "WORDCOUNTLABEL".hashValue)
        static let placeholdFont = UnsafeRawPointer(bitPattern: "PLACEHOLDFONT".hashValue)
        static let placeholdColor = UnsafeRawPointer(bitPattern: "PLACEHOLDCOLOR".hashValue)
        static let limitLabelFont = UnsafeRawPointer(bitPattern: "LIMITLABELFONT".hashValue)
        static let limitLabelColor = UnsafeRawPointer(bitPattern: "LIMITLABLECOLOR".hashValue)
    }

    /// 占位符
    public var placeholder: String {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholder!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            initPlaceholder(placeholder)
            addObserver()
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholder!) as? String ?? ""
        }
    }

    /// 占位符字体
    public var placeholdFont: UIFont {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholdFont!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            placeholderLabel?.font = placeholdFont
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdFont!) as? UIFont ?? UIFont.systemFont(ofSize: 17)
        }
    }

    /// 占位符字体颜色
    public var placeholdColor: UIColor {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholdColor!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            placeholderLabel?.textColor = placeholdColor
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdColor!) as? UIColor ?? UIColor.lightGray
        }
    }

    /// 限制字数长度
    public var limitLength: Int {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLength!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            initWordCountLabel(limitLength)
            addObserver()
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLength!) as? Int ?? 0
        }
    }

    /// 限制字数Label字体
    public var limitLabelFont: UIFont {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLabelFont!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            wordCountLabel?.font = limitLabelFont
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelFont!) as? UIFont ?? UIFont.systemFont(ofSize: 13)
        }
    }

    /// 限制字数Label字体颜色
    public var limitLabelColor: UIColor {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLabelColor!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            wordCountLabel?.textColor = limitLabelColor
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelColor!) as? UIColor ?? UIColor.lightGray
        }
    }

    /// 限制的行数,优先级比限制字数低
    public var limitLines: Int {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLines!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            addObserver()
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLines!) as? Int ?? 0
        }
    }

    /// 移除观察
    /// 如果不移除，在iOS11以下会因为没有移除观察引起crash
    public func removeObserver() {
        NotificationCenter.default.removeObserver(self)
        if #available(iOS 11, *) {
        } else {
            for key in UITextView.observingKeys {
                removeObserver(self, forKeyPath: key)
            }
        }
    }

    private var placeholderLabel: UILabel? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholderLabel!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholderLabel!) as? UILabel
        }
    }

    private var wordCountLabel: UILabel? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.wordCountLabel!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.wordCountLabel!) as? UILabel
        }
    }

    /// 字数限制label高度
    private static let wordCountLabelHeight: CGFloat = 20

    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: UITextView.textDidChangeNotification, object: self)
        for key in UITextView.observingKeys {
            addObserver(self, forKeyPath: key, options: .new, context: nil)
        }
        setupSubviews()
    }

    // swiftlint:disable block_based_kvo
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        textChange()
        setupSubviews()
    }

    private func initPlaceholder(_ placeholder: String) {
        placeholderLabel = UILabel()
        placeholderLabel?.font = placeholdFont
        placeholderLabel?.text = placeholder
        placeholderLabel?.numberOfLines = 0
        placeholderLabel?.lineBreakMode = .byCharWrapping
        placeholderLabel?.textColor = placeholdColor
        addSubview(placeholderLabel!)
        placeholderLabel?.isHidden = text.count > 0 ? true : false
    }

    private func initWordCountLabel(_ limitLength: Int) {
        wordCountLabel?.removeFromSuperview()
        wordCountLabel = UILabel()
        wordCountLabel?.textAlignment = .right
        wordCountLabel?.adjustsFontSizeToFitWidth = true
        wordCountLabel?.textColor = limitLabelColor
        wordCountLabel?.font = limitLabelFont
        if text.count > limitLength {
            text = (text as NSString).substring(to: limitLength)
        }
        wordCountLabel?.backgroundColor = backgroundColor
        wordCountLabel?.text = "\(text.count)/\(limitLength)"
        addSubview(wordCountLabel!)
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: UITextView.wordCountLabelHeight + textContainerInset.bottom, right: 0)
    }

    @objc
    private func textChange() {
        if placeholder.tx.isNotEmpty {
            if text.count == 0 {
                placeholderLabel?.isHidden = false
            } else {
                placeholderLabel?.isHidden = true
            }
        }
        if limitLength > 0 {
            if markedTextRange == nil {
                if text.count > limitLength {
                    text = (text as NSString).substring(to: limitLength)
                }
                wordCountLabel?.text = "\(text.count)/\(limitLength)"
            }
        } else if limitLines > 0 {
            var size = getStringPlaceSize(text, textFont: font!)
            let height = font!.lineHeight * CGFloat(limitLines)
            if size.height > height {
                while size.height > height {
                    text = (text as NSString).substring(to: text.count - 1)
                    size = getStringPlaceSize(text, textFont: font!)
                }
            }
        }
    }

    @objc
    private func getStringPlaceSize(_ string: String, textFont: UIFont) -> CGSize {
        let attribute = [NSAttributedString.Key.font: textFont]
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = string.boundingRect(with: CGSize(width: contentSize.width - textContainer.lineFragmentPadding * 2, height: CGFloat.greatestFiniteMagnitude), options: options, attributes: attribute, context: nil).size
        return size
    }

    private func setupSubviews() {
        if limitLength > 0, wordCountLabel != nil {
            wordCountLabel!.frame = CGRect(x: 0,
                                           y: bounds.height - UITextView.wordCountLabelHeight + contentOffset.y,
                                           width: bounds.width - textContainer.lineFragmentPadding,
                                           height: UITextView.wordCountLabelHeight)
        }

        if placeholder.tx.isNotEmpty, placeholderLabel != nil {
            let width = bounds.width - textContainer.lineFragmentPadding * 2
            let size = placeholderLabel!.sizeThatFits(CGSize(width: width, height: .zero))
            placeholderLabel!.frame = CGRect(x: textContainer.lineFragmentPadding,
                                             y: textContainerInset.top,
                                             width: size.width,
                                             height: size.height)
        }

        wordCountLabel?.backgroundColor = backgroundColor
    }
}
