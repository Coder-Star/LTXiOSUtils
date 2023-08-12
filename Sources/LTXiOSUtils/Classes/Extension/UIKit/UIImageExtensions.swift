//
//  UIImageExtensions.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2019/11/21.
//

import Foundation
import UIKit

/// 压缩类型
public enum ImageCompressType {
    /// 某一边最大为800
    case session
    /// 某一边最大为1200(默认)
    case timeline
}

// MARK: - UIImage压缩相关

extension TxExtensionWrapper where Base: UIImage {
    /// 压缩图片
    /// 注意压缩后含有透明背景图片的背景会变成白色
    /// - Parameter type: 压缩类型
    /// - Returns: 压缩后的图片
    public func compress(type: ImageCompressType = .timeline) -> UIImage {
        let size = wxImageSize(type: type)
        let reImage = resizedImage(size: size)
        let data = reImage.jpegData(compressionQuality: 0.5)!
        return UIImage(data: data)!
    }

    private func wxImageSize(type: ImageCompressType) -> CGSize {
        var width = base.size.width
        var height = base.size.height
        var boundary: CGFloat = 1_280

        guard width > boundary || height > boundary else {
            return CGSize(width: width, height: height)
        }

        let s = max(width, height) / min(width, height)
        if s <= 2 {
            let maxValue = max(width, height) / boundary
            if width > height {
                width = boundary
                height /= maxValue
            } else {
                height = boundary
                width /= maxValue
            }
        } else {
            if min(width, height) >= boundary {
                boundary = type == .session ? 800 : 1_280
                let minValue = min(width, height) / boundary
                if width < height {
                    width = boundary
                    height /= minValue
                } else {
                    height = boundary
                    width /= minValue
                }
            }
        }
        return CGSize(width: width, height: height)
    }

    private func resizedImage(size: CGSize) -> UIImage {
        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        var newImage: UIImage!
        UIGraphicsBeginImageContext(newRect.size)
        newImage = UIImage(cgImage: base.cgImage!, scale: 1, orientation: base.imageOrientation)
        newImage.draw(in: newRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

// MARK: - 扩展

extension TxExtensionWrapper where Base: UIImage {
    /// 设置图片尺寸
    ///
    /// - Parameter reSize: 图片尺寸
    /// - Returns: 处理后的图片
    public func setSize(reSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale)
        base.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }

    /// 缩放图片
    ///
    /// - Parameter scaleSize: 缩放比例
    /// - Returns: 缩放后的图片
    public func scaleImage(scaleSize: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: base.size.width * scaleSize, height: base.size.height * scaleSize), false, UIScreen.main.scale)
        base.draw(in: CGRect(x: 0, y: 0, width: base.size.width * scaleSize, height: base.size.height * scaleSize))
        let reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }

    /// 设置图片尺寸
    /// 宽度固定，高度按照原始尺寸
    /// - Parameter width: 宽度
    /// - Parameter scale: 放大倍数，0表示使用当前屏幕像素
    /// - Returns: 处理好的图片
    public func resize(width: CGFloat, scale: CGFloat = 0) -> UIImage {
        var result: UIImage?
        let size = base.size
        if width != size.width, size.width != 0 {
            let height = width / size.width * size.height
            UIGraphicsBeginImageContextWithOptions(CGSize(width: Int(width), height: Int(height)), false, scale)
            base.draw(in: CGRect(x: 0, y: 0, width: Int(width), height: Int(height)))
            result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return result ?? UIImage()
    }

    /// 设置图片尺寸
    /// 高度固定，宽度按照原始比例
    /// - Parameter height: 高度
    /// - Parameter scale: 放大倍数，0表示使用当前屏幕像素
    /// - Returns: 处理好的图片
    public func resize(height: CGFloat, scale: CGFloat = 0) -> UIImage {
        var result: UIImage?
        let size = base.size
        if height != size.height, size.height != 0 {
            let width = height / size.height * size.width
            UIGraphicsBeginImageContextWithOptions(CGSize(width: Int(width), height: Int(height)), false, scale)
            base.draw(in: CGRect(x: 0, y: 0, width: Int(width), height: Int(height)))
            result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return result ?? UIImage()
    }

    /// 压缩到指定尺寸以下
    /// - Parameter toBytes: 字节数
    /// - Returns: 压缩后的data，如果压缩失败或者压缩到最小压缩率还不到要求，则返回nil
    public func compressOriginalImage(toBytes: Int) -> Data? {
        var compression: CGFloat = 1
        let minCompression: CGFloat = 0.1
        guard var imageData = base.jpegData(compressionQuality: compression) else {
            return nil
        }
        if imageData.count < toBytes {
            return imageData
        }
        while imageData.count > toBytes, compression > minCompression {
            compression -= 0.1
            guard let tempData = base.jpegData(compressionQuality: compression) else {
                return nil
            }
            imageData = tempData
        }
        if imageData.count > toBytes {
            return nil
        }
        return imageData
    }

    /// 图片旋转
    ///
    /// - Parameter orientation: 旋转方向
    /// - Returns: 旋转后的图片
    public func rotate(orientation: UIImage.Orientation) -> UIImage {
        return UIImage(cgImage: base.cgImage!, scale: base.scale, orientation: orientation)
    }

    /// 修改UIImage的颜色
    ///
    /// - Parameter color: 修改成的颜色
    /// - Returns: 修改颜色后的UIImage
    public func withTintColor(color: UIColor) -> UIImage? {
        // 第二个参数为 opaque ，将其设置为false，避免图片重绘后导致图片四周出现边框
        UIGraphicsBeginImageContextWithOptions(base.size, false, 0)
        color.setFill()
        let bounds = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
        UIRectFill(bounds)
        base.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
}

extension TxExtensionWrapper where Base: UIImage {
    /// 获取其他Bundle中的图片
    /// - Parameters:
    ///   - named: 图片名称
    ///   - bundleName: bundleName
    ///   - podName: podName，当使用framwork时使用，如果为nil，赋值为bundleName
    /// - Returns: UIImage?
    /// - Note: 当使用framework方式引用三方库时，每一个三方库都会在Frameworks下面以一个单独的framework存在
    @available(iOS 8.0, *)
    public static func getImage(named: String, bundleName: String, podName: String? = nil) -> UIImage? {
        let bundle = Bundle.tx.getBundle(bundleName: bundleName, podName: podName)
        return UIImage(named: named, in: bundle, compatibleWith: nil)
    }
}
