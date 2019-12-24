//
//  UIColorExtensions.swift
//  LTXiOSUtils
//  颜色工具类以及扩展
//  Created by 李天星 on 2019/8/2.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 颜色扩展
public extension UIColor {

    /// 颜色hex值转颜色，如果hex值去除头部符号后不满6位，返回默认色-白色
    ///
    /// - Parameters:
    ///   - hexString: hex值
    ///   - alpha: 透明度
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.lowercased()

        if hexString.hasPrefix("#") {
            hexString = String(hexString.dropFirst())
        }
        if hexString.hasPrefix("0x") {
            hexString = String(hexString.dropFirst(2))
        }
        //hex值少于6位，返回白色
        if hexString.count < 6 {
            self.init(red: 255, green: 255, blue: 255, alpha: alpha)
        } else {
            let scanner = Scanner(string: hexString)
            var color: UInt32 = 0
            scanner.scanHexInt32(&color)

            let mask = 0x000000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask

            let red   = CGFloat(r) / 255.0
            let green = CGFloat(g) / 255.0
            let blue  = CGFloat(b) / 255.0

            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
    }

    /// 颜色转hex值
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        } else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }

    /// 颜色的反色
    var invertColor: UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: nil)
        return UIColor(red:1.0 - r, green: 1.0 - g, blue: 1.0 - b, alpha: 1)
    }

}

// MARK: - 颜色、图片
public extension UIColor {

    /// 颜色生成指定大小的UIImage
    ///
    /// - Parameter size: 图片尺寸
    /// - Returns: 图片
    func toImage(size: CGSize) -> UIImage? {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(self.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return image
    }
}

public extension UIColor {
    /// 适配暗黑模式
    /// - Parameter colorWithDark: 暗黑模式下的颜色,默认为nil，取颜色反色
    func adaptDark(_ colorWithDark: UIColor? = nil) -> UIColor {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                guard let darkColor = colorWithDark else {
                    return self.invertColor
                }
                return darkColor
            }
        } else {
            return self
        }
        return self
    }

    /// 适配各种模式
    /// - Parameter colorWithDark: 暗黑模式颜色
    func adapt(colorWithDark: UIColor? = nil) -> UIColor {
        return self.adaptDark(colorWithDark)
    }
}
