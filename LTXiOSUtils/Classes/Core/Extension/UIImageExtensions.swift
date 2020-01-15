//
//  UIImageExtensions.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/11/21.
//

import UIKit
import Foundation

/// 压缩类型
public enum ImageCompressType {
    /// 某一边最大为800
    case session
    /// 某一边最大为1200(默认)
    case timeline
}

// MARK: - UIImage压缩相关
public extension UIImage {

    /// 压缩图片
    /// 注意压缩后含有透明背景图片的背景会变成白色
    /// - Parameter type: 压缩类型
    /// - Returns: 压缩后的图片
    func compress(type: ImageCompressType = .timeline) -> UIImage {
        let size = self.wxImageSize(type: type)
        let reImage = resizedImage(size: size)
        let data = reImage.jpegData(compressionQuality: 0.5)!
        return UIImage.init(data: data)!
    }

    private func wxImageSize(type: ImageCompressType) -> CGSize {
        var width = self.size.width
        var height = self.size.height
        var boundary: CGFloat = 1280

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
                boundary = type == .session ? 800 : 1280
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
        newImage = UIImage(cgImage: self.cgImage!, scale: 1, orientation: self.imageOrientation)
        newImage.draw(in: newRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

}

// MARK: - 扩展
public extension UIImage {

    /// 设置图片尺寸
    ///
    /// - Parameter reSize: 图片尺寸
    /// - Returns: 处理后的图片
    func setSize(reSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }

    /// 缩放图片
    ///
    /// - Parameter scaleSize: 缩放比例
    /// - Returns: 缩放后的图片
    func scaleImage(scaleSize: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize), false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width * scaleSize, height: self.size.height * scaleSize))
        let reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }

    /// 图片旋转
    ///
    /// - Parameter orientation: 旋转方向
    /// - Returns: 旋转后的图片
    func rotate(orientation: Orientation) -> UIImage {
        return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: orientation)
    }
}
