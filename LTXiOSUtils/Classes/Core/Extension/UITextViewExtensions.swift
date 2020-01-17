//
//  UITextViewExtensions.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2020/1/15.
//

import Foundation
import UIKit

// MARK: - 如果对textView.text直接赋值。请在设置属性之前进行，否则影响计算
// MARK: - 取消对UITextView的监听无法在扩展中进行，需要在业务中进行处理

// MARK: - UITextView占位符以及最大字数等
extension UITextView {

    private struct RuntimeKey {
        static let placeholder = UnsafeRawPointer.init(bitPattern: "PLACEHOLDEL".hashValue)
        static let limitLength = UnsafeRawPointer.init(bitPattern: "LIMITLENGTH".hashValue)
        static let limitLines = UnsafeRawPointer.init(bitPattern: "LIMITLINES".hashValue)
        static let placeholderLabel = UnsafeRawPointer.init(bitPattern: "PLACEHOLDELABEL".hashValue)
        static let wordCountLabel = UnsafeRawPointer.init(bitPattern: "WORDCOUNTLABEL".hashValue)
        static let placeholdFont = UnsafeRawPointer.init(bitPattern: "PLACEHOLDFONT".hashValue)
        static let placeholdColor = UnsafeRawPointer.init(bitPattern: "PLACEHOLDCOLOR".hashValue)
        static let limitLabelFont = UnsafeRawPointer.init(bitPattern: "LIMITLABELFONT".hashValue)
        static let limitLabelColor = UnsafeRawPointer.init(bitPattern: "LIMITLABLECOLOR".hashValue)
    }

    /// 占位符
    public var placeholder: String {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholder!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            initPlaceholder(placeholder)
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholder!) as? String ?? ""
        }
    }

    /// 占位符字体
    public var placeholdFont: UIFont {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholdFont!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.placeholderLabel?.font = placeholdFont
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdFont!) as? UIFont ?? UIFont.systemFont(ofSize: 17)
        }
    }

    /// 占位符字体颜色
    public var placeholdColor: UIColor {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholdColor!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.placeholderLabel?.textColor = placeholdColor
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
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLength!) as? Int ?? 0
        }
    }

    /// 限制字数Label字体
    public var limitLabelFont: UIFont {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLabelFont!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.wordCountLabel?.font = limitLabelFont
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelFont!) as? UIFont ?? UIFont.systemFont(ofSize: 13)
        }
    }

    /// 限制字数Label字体颜色
    public var limitLabelColor: UIColor {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLabelColor!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.wordCountLabel?.textColor = limitLabelColor
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelColor!) as? UIColor ?? UIColor.lightGray
        }
    }

    /// 限制的行数,优先级比限制字数低
    public var limitLines: Int {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLines!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: UITextView.textDidChangeNotification, object: self)
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLines!) as? Int ?? 0
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

    private static let placeholderLabelLeftAndRightMargin:CGFloat = 7

    private func initPlaceholder(_ placeholder: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: UITextView.textDidChangeNotification, object: self)
        placeholderLabel = UILabel()
        placeholderLabel?.font = self.placeholdFont
        placeholderLabel?.text = placeholder
        placeholderLabel?.numberOfLines = 0
        placeholderLabel?.lineBreakMode = .byCharWrapping
        placeholderLabel?.textColor = self.placeholdColor
        addSubview(self.placeholderLabel!)
        placeholderLabel?.isHidden = self.text.count > 0 ? true : false
    }

    private func initWordCountLabel(_ limitLength : Int) {
        NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: UITextView.textDidChangeNotification, object: self)
        wordCountLabel?.removeFromSuperview()
        wordCountLabel = UILabel()
        wordCountLabel?.textAlignment = .right
        wordCountLabel?.adjustsFontSizeToFitWidth = true
        wordCountLabel?.textColor = self.limitLabelColor
        wordCountLabel?.font = self.limitLabelFont
        if self.text.count > limitLength {
            self.text = (self.text as NSString).substring(to: limitLength)
        }
        wordCountLabel?.text = "\(self.text.count)/\(limitLength)"
        addSubview(wordCountLabel!)
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }

    @objc private func textChange() {
        if placeholder.isNotEmpty {
            if self.text.count ==  0 {
                placeholderLabel?.isHidden = false
            } else {
                placeholderLabel?.isHidden = true
            }
        }
        if limitLength > 0 {
            if self.text.count > limitLength {
                self.text = (self.text as NSString).substring(to: limitLength)
            }
            wordCountLabel?.text = "\(self.text.count)/\(limitLength)"
        } else if limitLines > 0 {
            var size = getStringPlaceSize(self.text, textFont: self.font!)
            let height = self.font!.lineHeight * CGFloat(limitLines)
            if size.height > height {
                while size.height > height {
                    self.text = (self.text as NSString).substring(to: self.text.count - 1)
                    size = getStringPlaceSize(self.text, textFont: self.font!)
                }
            }
        }
    }

    @objc private func getStringPlaceSize(_ string: String, textFont: UIFont) -> CGSize {
        let attribute = [NSAttributedString.Key.font: textFont]
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = string.boundingRect(with: CGSize(width: self.contentSize.width-10, height: CGFloat.greatestFiniteMagnitude), options: options, attributes: attribute, context: nil).size
        return size
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        if limitLength > 0 && wordCountLabel != nil {
            wordCountLabel!.frame = CGRect(x: 0, y: frame.height - 20 + contentOffset.y, width: frame.width - 10, height: 20)
        }
        if placeholder.isNotEmpty && placeholderLabel != nil {
            let width = frame.width - UITextView.placeholderLabelLeftAndRightMargin * 2
            let size = placeholderLabel!.sizeThatFits(CGSize(width: width, height: .zero))
            placeholderLabel!.frame = CGRect(x: UITextView.placeholderLabelLeftAndRightMargin, y: 8, width: size.width, height: size.height)
        }
    }
}
