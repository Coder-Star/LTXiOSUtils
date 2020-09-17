//
//  NSMutableAttributedStringExtensions.swift
//  LTXiOSUtils
//  NSMutableAttributedString扩展
//  Created by 李天星 on 2020/3/17.
//

import Foundation

// MARK: - 富文本文字样式相关
/// 字体样式
public enum FontStyle {
    /// 默认
    case `default`
    /// 粗体
    case bold
    /// 斜体
    case italic
    /// 粗斜体
    case boldItalic
}

extension TxExtensionWrapper where Base: NSMutableAttributedString {

    private var allRange: NSRange {
        let str = self.base.string
        let theRange = NSString(string: str).range(of: str)
        return theRange
    }

    /// 添加字体
    /// - Parameters:
    ///   - fontName: 字体名称
    ///   - fontStyle: 字体样式
    ///   - fontSize: 字体尺寸
    public func addFontStyle(fontName: String = "", fontStyle: FontStyle, fontSize: CGFloat) -> NSMutableAttributedString {
        var font = UIFont.systemFont(ofSize: fontSize)
        switch fontStyle {
        case .default:
            break
        case .bold:
            font = UIFont.tx.boldFont(name: fontName, size: fontSize)
        case .italic:
            font = UIFont.tx.italicFont(name: fontName, size: fontSize)
        case .boldItalic:
            font = UIFont.tx.boldItalicFont(name: fontName, size: fontSize)
        }
        self.base.addAttribute(NSMutableAttributedString.Key.font, value: font, range: self.allRange)
        return self.base
    }

    /// 添加下划线
    /// - Parameters:
    ///   - underlineStyle: 下划线样式，默认为single
    ///   - underlineColor: 下划线颜色，默认为nil,nil时跟字体颜色保持相同
    public func addUnderline(style underlineStyle: NSUnderlineStyle = .single, color underlineColor: UIColor? = nil) -> NSMutableAttributedString {
        self.base.addAttribute(NSMutableAttributedString.Key.underlineStyle, value: underlineStyle, range: self.allRange)
        if let tempColor = underlineColor {
            self.base.addAttribute(NSMutableAttributedString.Key.underlineColor, value: tempColor, range: self.allRange)
        }
        return self.base
    }

    /// 添加删除线
    /// - Parameters:
    ///   - strikethroughStyle: 删除线样式，默认为single
    ///   - strikethroughColor: 删除线样式，默认为nil,nil时跟字体颜色保持相同
    public func addStrikethrough(style strikethroughStyle: NSUnderlineStyle = .single, color strikethroughColor: UIColor? = nil) -> NSMutableAttributedString {
        self.base.addAttribute(NSMutableAttributedString.Key.strikethroughStyle, value: strikethroughStyle, range: self.allRange)
        if let tempColor = strikethroughColor {
            self.base.addAttribute(NSMutableAttributedString.Key.strikethroughColor, value: tempColor, range: self.allRange)
        }
        return self.base
    }
}
