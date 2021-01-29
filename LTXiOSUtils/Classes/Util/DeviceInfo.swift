//
//  DeviceInfo.swift
//  LTXiOSUtils
//  设备信息
//  Created by 李天星 on 2021/1/26.
//

import Foundation

/// 设置相关信息
public struct DeviceInfo {

    /// statusBar高度
    ///
    /// 状态栏高度，非刘海屏20；其余型号不一致，其中iPhone11 Pro 为44，iPhone12 Pro Max 47；
    public static var statusBarHeight: CGFloat {
        var result: CGFloat = 20
        if UIApplication.shared.statusBarFrame.height > 0 {
            // 当状态栏隐藏时，UIApplication.shared.statusBarFrame.height取到的值为0
            result = UIApplication.shared.statusBarFrame.height
        } else if #available(iOS 11.0, *) {
            if let safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets {
                // 使用max的原因是出现屏幕旋转情况
                result = max(result, safeAreaInsets.top)
                result = max(result, safeAreaInsets.left)
                result = max(result, safeAreaInsets.bottom)
                result = max(result, safeAreaInsets.right)
            }
        }
        return result
    }
}
