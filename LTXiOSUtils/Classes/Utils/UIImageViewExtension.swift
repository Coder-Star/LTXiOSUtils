//
//  UIImageViewExtension.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/11/21.
//

import Foundation

// MARK: - 加载gif图片
extension UIImageView {
    /// 加载本地gif文件
    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    /// 加载远程gif文件
    public func loadGif(url: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(url: url)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

}
