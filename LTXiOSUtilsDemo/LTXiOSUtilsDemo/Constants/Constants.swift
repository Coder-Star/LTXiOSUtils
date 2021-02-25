//
//  Constants.swift
//  LTXiOSUtilsDemo
//  静态属性
//  Created by 李天星 on 2019/11/19.
//  Copyright © 2019 李天星. All rights reserved.
//

public enum OpenType: String {
    case `default` = ""
    case tel = "tel://"
    case email = "mailto:"
}

/// 常量
public struct Constants {

    /// 尺寸
    public struct Size {
        static let WIDTH = UIScreen.main.bounds.size.width
        static let HEIGHT = UIScreen.main.bounds.size.height
    }

    /// 关键key
    public struct Keys {
        static let estimatedProgress = "estimatedProgress"
    }

    /// 第三方url
    public struct OpenUrl {
        /// 将字符串作为第三方url打开
        /// - Parameters:
        ///   - url: url
        ///   - type: 类型
        public static func open(url: String, type: OpenType) {
            guard let url = URL(string: type.rawValue + url), UIApplication.shared.canOpenURL(url) else {
                Log.d("该url暂不支持打开")
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }

    }
}

extension Constants {
    enum AppGroupIdentifier: String {
        case common = "group.com.star.LTXiOSUtils.extension"
    }
}
