//
//  ConstantsEnum.swift
//  LTXiOSUtils
//  常量
//  Created by 李天星 on 2019/11/19.
//

import Foundation

/// 常量类
public enum ConstantsEnum {
    /// 图片
    static let image = "image"
    /// 标题
    static let title = "title"
    /// 编码
    static let code = "code"
    /// tableCell
    static let cell = "cell"

    /// 尺寸相关
    public enum SizeEnum {
        /// 当前设备屏幕宽度
        static let screenWith = UIScreen.main.bounds.width
        /// 当前设备屏幕的高度
        static let screenHeight = UIScreen.main.bounds.height
        /// iphone较小宽度 4/4s/5/5s/5c
        static let iphoneSmallWidth:CGFloat = 320
        /// iphone中间宽度 6/6s/7/8/x
        static let iphoneMiddleWidth:CGFloat = 375
        /// iphone较大宽度 6+/6S+/7+/8+
        static let iphoneBigWidth:CGFloat = 414
        /// 状态栏高度，其中iphone x为44，其他为20
        static let statusBarFrameHeight = UIApplication.shared.statusBarFrame.size.height
    }

    /// iOS内部关键key值
    public enum KeyEnum {
        /// webview进度条keypath
        static let webViewProgressKeyPath = "estimatedProgress"
    }

}
