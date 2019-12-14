//
//  UIImageExtension.swift
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
extension UIImage {

    /// 压缩图片
    /// 注意压缩后含有透明背景图片的背景会变成白色
    /// - Parameter type: 压缩类型
    /// - Returns: 压缩后的图片
    public func compress(type: ImageCompressType = .timeline) -> UIImage {
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
extension UIImage {

    /// 设置图片尺寸
    ///
    /// - Parameter reSize: 图片尺寸
    /// - Returns: 处理后的图片
    public func setSize(reSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }

    /// 缩放图片
    ///
    /// - Parameter scaleSize: 缩放比例
    /// - Returns: 缩放后的图片
    public func scaleImage(scaleSize:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width:self.size.width * scaleSize , height: self.size.height * scaleSize),false,UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width * scaleSize, height: self.size.height * scaleSize))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }

    /// 图片旋转
    ///
    /// - Parameter orientation: 旋转方向
    /// - Returns: 旋转后的图片
    public func rotate(orientation:Orientation) -> UIImage {
        return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: orientation)
    }
}

// MARK: - 加载gif图片
extension UIImage {
    /// 加载gif图片data数据
    public class func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }

        return UIImage.animatedImageWithSource(source)
    }

    /// 加载远程gif文件
    public class func gif(url: String) -> UIImage? {
        guard let bundleURL = URL(string: url) else {
            return nil
        }

        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return nil
        }
        return gif(data: imageData)
    }

    /// 加载本地gif文件
    public class func gif(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return nil
        }
        return gif(data: imageData)
    }

    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.0000005
        let minDelay = 0.0000005
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }

        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)

        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        delay = delayObject as? Double ?? 0

        if delay < minDelay {
            delay = minDelay
        }

        return delay
    }

    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }

        if a! < b! {
            let c = a
            a = b
            b = c
        }

        var rest: Int
        while true {
            rest = a! % b!
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }

    internal class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }
        var gcd = array[0]
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        return gcd
    }

    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),source: source)
            delays.append(Int(delaySeconds * 2000.0))
        }

        let duration: Int = {
            var sum = 0
            for val: Int in delays {
                sum += val
            }
            return sum
        }()

        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        let animation = UIImage.animatedImage(with: frames,duration: Double(duration) / 3000.0)
        return animation
    }

}
