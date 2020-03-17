//
//  UIFontExtensions.swift
//  LTXiOSUtils
//  UIFont扩展
//  Created by 李天星 on 2020/3/17.
//

import Foundation

public extension UIFont {

    /// 粗体
    /// - Parameter fontName: 字体名称，为空时使用系统字体，默认为空
    /// - Parameter fontSize: 字体尺寸
    class func boldFont(name fontName: String = "", size fontSize: CGFloat) -> UIFont {
        var tempFontName = fontName
        if tempFontName.isEmpty {
            tempFontName = UIFont.systemFont(ofSize: fontSize).fontName
        }
        var descriptor = UIFontDescriptor(name: tempFontName, size: fontSize)
        if let tempDescriptor = descriptor.withSymbolicTraits([.traitBold]) {
            descriptor = tempDescriptor
        }
        let font = UIFont(descriptor: descriptor, size: fontSize)
        return font
    }

    /// 斜体
    /// - Parameters:
    ///   - fontName: 字体名称，为空时使用系统字体，默认为空
    ///   - fontSize: 字体尺寸
    class func italicFont(name fontName: String = "", size fontSize: CGFloat) -> UIFont {
        let matrix = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(15 * Float.pi / 180)), d: 1, tx: 0, ty: 0)
        var tempFontName = fontName
        if tempFontName.isEmpty {
            tempFontName = UIFont.systemFont(ofSize: fontSize).fontName
        }
        let descriptor = UIFontDescriptor(name: tempFontName, matrix: matrix)
        let font = UIFont(descriptor: descriptor, size: fontSize)
        return font
    }

    /// 粗体、斜体
    /// 如果粗体生成失败，则会返回斜体
    /// - Parameter fontName: 字体名称，为空时使用系统字体，默认为空
    /// - Parameter fontSize: 字体尺寸
    class func boldItalicFont(name fontName: String = "", size fontSize: CGFloat) -> UIFont {
        let matrix = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(15 * Float.pi / 180)), d: 1, tx: 0, ty: 0)
        var tempFontName = fontName
        if tempFontName.isEmpty {
            tempFontName = UIFont.systemFont(ofSize: fontSize).fontName
        }
        var descriptor = UIFontDescriptor(name: tempFontName, matrix: matrix)
        if let tempDescriptor = descriptor.withSymbolicTraits([.traitBold]) {
            descriptor = tempDescriptor
        }
        let font = UIFont(descriptor: descriptor, size: fontSize)
        return font
    }
}
