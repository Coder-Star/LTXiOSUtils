//
//  ClickableLabel.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2022/7/29.
//

import UIKit

public protocol ClickableLabelDelegate: AnyObject {
    /// 点击回调
    /// - Parameter label: Label
    /// - Parameter clickText: 可点击文字
    func clickableLabel(label: ClickableLabel, clickText text: String)
}

public class ClickableLabel: UILabel {
    /// 可点击文字背景颜色
    public var clickBackgroundColor: UIColor?

    /// 可点击文字背景颜色 点击松开后 保留时间
    public var clickBackgroundColorDuration: TimeInterval = 0.15

    public weak var delegate: ClickableLabelDelegate?

    /// 可点击文本颜色
    public var clickTextColor: UIColor? {
        didSet {
            updateTextStorage()
        }
    }

    /// 精确匹配
    public var clickTextArr: [String] = [] {
        didSet {
            updateTextStorage()
        }
    }

    /// 通配
    /// 筛选可点击文本正则表达式
    /// "#.+?#"：两个 # # 之间不为空
    public var clickTextPatterns: [String] = [] {
        didSet {
            updateTextStorage()
        }
    }

    // MARK: 私有属性

    private lazy var linkRanges = [NSRange]()
    private var selectedRange: NSRange?
    private lazy var textStorage = NSTextStorage()
    private lazy var layoutManager = NSLayoutManager()
    private lazy var textContainer = NSTextContainer()
    private lazy var textLineBreakMode: NSLineBreakMode = .byTruncatingTail

    override public var text: String? {
        didSet {
            updateTextStorage()
        }
    }

    override public var attributedText: NSAttributedString? {
        didSet {
            updateTextStorage()
        }
    }

    override public var font: UIFont! {
        didSet {
            updateTextStorage()
        }
    }

    override public var textColor: UIColor! {
        didSet {
            updateTextStorage()
        }
    }

    public override var lineBreakMode: NSLineBreakMode {
        didSet {
            textLineBreakMode = lineBreakMode
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        prepareLabel()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareLabel()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }

    private func prepareLabel() {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        isUserInteractionEnabled = true
    }

    public override func drawText(in rect: CGRect) {
        let range = glyphsRange
        let offset = glyphsOffset(range)

        layoutManager.drawBackground(forGlyphRange: range, at: offset)
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint.zero)
    }
}

extension ClickableLabel {
    private var glyphsRange: NSRange {
        return NSRange(location: 0, length: textStorage.length)
    }

    private func glyphsOffset(_ range: NSRange) -> CGPoint {
        let rect = layoutManager.boundingRect(forGlyphRange: range, in: textContainer)
        let height = (bounds.height - rect.height) * 0.5

        return CGPoint(x: 0, y: height)
    }
}

extension ClickableLabel {
    private func updateTextStorage() {
        guard let attributedText = attributedText, !attributedText.string.isEmpty else {
            return
        }

        let attrStringM = addLineBreak(attributedText)
        regexLinkRanges(attrStringM)
        addLinkAttribute(attrStringM)

        textStorage.setAttributedString(attrStringM)
        textContainer.lineBreakMode = textLineBreakMode

        setNeedsDisplay()
    }

    /// lineBreakMode为换行，解决设置 text 属性时不换行的问题
    private func addLineBreak(_ attrString: NSAttributedString) -> NSMutableAttributedString {
        let attrStringM = NSMutableAttributedString(attributedString: attrString)
        var range = NSRange(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)
        var paragraphStyle = attributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle

        if paragraphStyle != nil {
            paragraphStyle!.lineBreakMode = .byWordWrapping
        } else {
            paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle!.lineBreakMode = .byWordWrapping
            attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            attrStringM.setAttributes(attributes, range: range)
        }

        return attrStringM
    }

    private func regexLinkRanges(_ attrString: NSAttributedString) {
        linkRanges.removeAll()
        let regexRange = NSRange(location: 0, length: attrString.length)

        for clickText in clickTextArr {
            linkRanges.append(NSString(string: attrString.string).range(of: clickText))
        }

        clickTextPatterns.forEach { pattern in
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
                let results = regex.matches(in: attrString.string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: regexRange)
                for r in results {
                    linkRanges.append(r.range(at: 0))
                }
            } catch {}
        }
    }

    private func addLinkAttribute(_ attrStringM: NSMutableAttributedString) {
        if attrStringM.length == 0 {
            return
        }

        var range = NSRange(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)

        attributes[NSAttributedString.Key.font] = font
        attributes[NSAttributedString.Key.foregroundColor] = textColor
        attrStringM.addAttributes(attributes, range: range)

        attributes[NSAttributedString.Key.foregroundColor] = clickTextColor ?? textColor
        for r in linkRanges {
            attrStringM.setAttributes(attributes, range: r)
        }
    }
}

// MARK: - touch events

extension ClickableLabel {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        selectedRange = linkRangeAtLocation(location)
        if selectedRange != nil {
            modifySelectedAttribute(true)
        } else {
            super.touchesBegan(touches, with: event)
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        if let range = linkRangeAtLocation(location) {
            if !(range.location == selectedRange?.location && range.length == selectedRange?.length) {
                modifySelectedAttribute(false)
                selectedRange = range
                modifySelectedAttribute(true)
            }
        } else {
            modifySelectedAttribute(false)
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let selectedRange = selectedRange else {
            super.touchesEnded(touches, with: event)
            return
        }
        let text = (textStorage.string as NSString).substring(with: selectedRange)
        delegate?.clickableLabel(label: self, clickText: text)
        DispatchQueue.main.asyncAfter(deadline: .now() + clickBackgroundColorDuration) {
            self.modifySelectedAttribute(false)
        }
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        modifySelectedAttribute(false)
    }

    private func modifySelectedAttribute(_ isSet: Bool) {
        guard let range = selectedRange else {
            return
        }

        guard let clickBackgroundColor = clickBackgroundColor else {
            return
        }

        var attributes = textStorage.attributes(at: 0, effectiveRange: nil)
        attributes[NSAttributedString.Key.foregroundColor] = clickTextColor ?? textColor

        if isSet {
            attributes[NSAttributedString.Key.backgroundColor] = clickBackgroundColor
        } else {
            attributes[NSAttributedString.Key.backgroundColor] = UIColor.clear
            selectedRange = nil
        }
        textStorage.addAttributes(attributes, range: range)
        setNeedsDisplay()
    }

    private func linkRangeAtLocation(_ location: CGPoint) -> NSRange? {
        if textStorage.length == 0 {
            return nil
        }

        let offset = glyphsOffset(glyphsRange)
        let point = CGPoint(x: offset.x + location.x, y: offset.y + location.y)
        let index = layoutManager.glyphIndex(for: point, in: textContainer)

        for r in linkRanges {
            if index >= r.location, index <= r.location + r.length {
                return r
            }
        }

        return nil
    }
}
