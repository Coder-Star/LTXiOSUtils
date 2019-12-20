//
//  SizeEnum.swift
//  LTXiOSUtils
//  尺寸相关常量
//  Created by 李天星 on 2019/12/20.
//

import Foundation

/// 尺寸相关常量
public enum SizeEnum {
    /// 当前设备屏幕宽度
    public static let screenWith = UIScreen.main.bounds.width
    /// 当前设备屏幕的高度
    public static let screenHeight = UIScreen.main.bounds.height
    /// iphone较小宽度 4/4s/5/5s/5c
    public static let iphoneSmallWidth: CGFloat = 320
    /// iphone中间宽度 6/6s/7/8/x
    public static let iphoneMiddleWidth: CGFloat = 375
    /// iphone较大宽度 6+/6S+/7+/8+
    public static let iphoneBigWidth: CGFloat = 414
    /// 状态栏高度，其中iphone x为44，其他为20
    public static let statusBarFrameHeight = UIApplication.shared.statusBarFrame.size.height
}
