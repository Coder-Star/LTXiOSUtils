//
//  UITextViewExtensions.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2020/1/15.
//

import Foundation
import UIKit

// MARK: 如果你想对textView.text直接赋值。请在设置属性之前进行，否则影响计算。
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
        static let autoHeight = UnsafeRawPointer.init(bitPattern: "AUTOHEIGHT".hashValue)
        static let oldFrame = UnsafeRawPointer.init(bitPattern: "LODFRAME".hashValue)
    }

    /// 占位符
    public var placeholder: String? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholder!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            initPlaceholder(placeholder!)
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholder!) as? String
        }
    }

    /// 字体
    public var placeholdFont: UIFont? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholdFont!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.placeholderLabel != nil {
                self.placeholderLabel?.font = placeholdFont
            }
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdFont!) as? UIFont == nil ? UIFont.systemFont(ofSize: 17) : objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdFont!) as? UIFont
        }
    }

    /// 字体颜色
    public var placeholdColor: UIColor? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholdColor!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.placeholderLabel != nil {
                self.placeholderLabel?.textColor = placeholdColor
            }
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdColor!) as? UIColor == nil ? UIColor.lightGray : objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdColor!) as? UIColor
        }
    }

    /// 限制字数长度
    public var limitLength: NSNumber? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLength!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            initWordCountLabel(limitLength!)
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLength!) as? NSNumber
        }
    }

    /// 限制字数Label字体
    public var limitLabelFont: UIFont? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLabelFont!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.wordCountLabel != nil {
                self.wordCountLabel?.font = limitLabelFont
            }
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelFont!) as? UIFont == nil ? UIFont.systemFont(ofSize: 13) : objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelFont!) as? UIFont
        }
    }

    /// 限制字数Label字体
    public var limitLabelColor: UIColor? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLabelColor!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.wordCountLabel != nil {
                self.wordCountLabel?.textColor = limitLabelColor
            }
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelColor!) as? UIColor == nil ? UIColor.lightGray : objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelColor!) as? UIColor
        }
    }

    /// 限制的行数
    public var limitLines: NSNumber? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLines!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            NotificationCenter.default.addObserver(self, selector: #selector(limitLengthEvent), name: UITextView.textDidChangeNotification, object: self)

        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLines!) as? NSNumber
        }
    }

    ///是否自动高度
    public var autoHeight: Bool? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.autoHeight!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.autoHeight!) as? Bool
        }
    }

    private var placeholderLabel: UILabel? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholderLabel!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholderLabel!) as? UILabel
        }
    }

    private var wordCountLabel: UILabel? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.wordCountLabel!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.wordCountLabel!) as? UILabel
        }
    }

    private var oldFrame: CGRect? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.oldFrame!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.oldFrame!) as? CGRect
        }
    }

    private static let placeholderLabelLeftAndRightMargin:CGFloat = 7

    private func initPlaceholder(_ placeholder: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(_:)), name: UITextView.textDidChangeNotification, object: self)
        self.placeholderLabel = UILabel()
        placeholderLabel?.font = self.placeholdFont
        placeholderLabel?.text = placeholder
        placeholderLabel?.numberOfLines = 0
        placeholderLabel?.lineBreakMode = .byWordWrapping
        placeholderLabel?.textColor = self.placeholdColor
        let rect = placeholder.boundingRect(with: CGSize(width: self.frame.size.width - UITextView.placeholderLabelLeftAndRightMargin * 2, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : self.placeholdFont!], context: nil)
        placeholderLabel?.frame = CGRect(x: UITextView.placeholderLabelLeftAndRightMargin, y: 10, width: rect.size.width, height: rect.size.height)
        addSubview(self.placeholderLabel!)
        placeholderLabel?.isHidden = self.text.count > 0 ? true : false
    }

    private func initWordCountLabel(_ limitLength : NSNumber) {
        NotificationCenter.default.addObserver(self, selector: #selector(limitLengthEvent), name: UITextView.textDidChangeNotification, object: self)
        if wordCountLabel != nil {
            wordCountLabel?.removeFromSuperview()
        }
        wordCountLabel = UILabel(frame: CGRect(x: 0, y: self.frame.size.height - 20, width: self.frame.size.width - 10, height: 20))
        wordCountLabel?.textAlignment = .right
        wordCountLabel?.textColor = self.limitLabelColor
        wordCountLabel?.font = self.limitLabelFont
        if self.text.count > limitLength.intValue {
            self.text = (self.text as NSString).substring(to: limitLength.intValue)
        }
        wordCountLabel?.text = "\(self.text.count)/\(limitLength)"
        addSubview(wordCountLabel!)
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }

    @objc private func textChange(_ notification : Notification) {
        guard let textView = notification.object as? UITextView else {
            return
        }
        self.text = textView.text
        if placeholder != nil {
            placeholderLabel?.isHidden = true
            if self.text.count ==  0 {
                self.placeholderLabel?.isHidden = false
            }
        }
        if limitLength != nil {
            var wordCount = self.text.count
            if wordCount > (limitLength?.intValue)! {
                wordCount = (limitLength?.intValue)!
            }
            let limit = limitLength!.stringValue
            wordCountLabel?.text = "\(wordCount)/\(limit)"
        }
        if autoHeight == true && self.oldFrame != nil {
            let size = getStringPlaceSize(self.text, textFont: self.font!)
            UIView.animate(withDuration: 0.15) {
                self.frame = CGRect.init(x: (self.oldFrame?.origin.x)!, y: (self.oldFrame?.origin.y)!, width: (self.oldFrame?.size.width)!, height: size.height + 25 <= (self.oldFrame?.size.height)! ? (self.oldFrame?.size.height)! : size.height + 25)
            }
        }

    }

    @objc private func limitLengthEvent() {
        if limitLength != nil {
            if self.text.count > (limitLength?.intValue)! && limitLength != nil {
                self.text = (self.text as NSString).substring(to: (limitLength?.intValue)!)
            }
        } else {
            if (limitLines != nil) {
                var size = getStringPlaceSize(self.text, textFont: self.font!)
                let height = self.font!.lineHeight * CGFloat(limitLines!.floatValue)
                if size.height > height {
                    while size.height > height {
                        self.text = (self.text as NSString).substring(to: self.text.count - 1)
                        size = getStringPlaceSize(self.text, textFont: self.font!)
                    }
                }
            }
        }
    }

    @objc private func getStringPlaceSize(_ string: String, textFont: UIFont) -> CGSize {
        let attribute = [NSAttributedString.Key.font : textFont]
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = string.boundingRect(with: CGSize(width: self.contentSize.width-10, height: CGFloat.greatestFiniteMagnitude), options: options, attributes: attribute, context: nil).size
        return size
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        if limitLength != nil && wordCountLabel != nil {
            //避免外部使用了约束 这里再次更新frame
            wordCountLabel!.frame = CGRect(x: 0, y: frame.height - 20 + contentOffset.y, width: frame.width - 10, height: 20)
        }
        if placeholder != nil && placeholderLabel != nil {
            let rect: CGRect = placeholder!.boundingRect(with: CGSize(width: frame.width - UITextView.placeholderLabelLeftAndRightMargin * 2, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: placeholdFont!], context: nil)
            placeholderLabel!.frame = CGRect(x: UITextView.placeholderLabelLeftAndRightMargin, y: 8, width: rect.size.width, height: rect.size.height)
        }
        if autoHeight == true {
            self.oldFrame = self.frame
            self.isScrollEnabled = false
        }
    }

    // MARK: - Swift分类不支持，在class业务里面使用
    //    deinit {
    //        NotificationCenter.default.removeObserver(self, name: .UITextViewTextDidChange, object: self)
    //
    //    }
    //

}
