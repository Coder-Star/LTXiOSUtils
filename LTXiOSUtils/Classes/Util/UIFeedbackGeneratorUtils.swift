//
//  UIFeedbackGeneratorUtils.swift
//  LTXiOSUtils
//  触感反馈工具类
//  Created by 李天星 on 2020/3/17.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import UIKit

/// 触感反馈类型
public enum FeedbackType: Int {
    /// 轻
    case light
    /// 中
    case medium
    /// 重
    case heavy

    /// 成功
    case success
    /// 警告
    case warning
    /// 失败
    case error

    /// 变化，选择时使用
    /// 如时间选择
    case change
}

/// 触感反馈工具类
public struct UIFeedbackGeneratorUtils {

    /// 触感反馈
    /// - Parameter style: 触感反馈类型
    public static func impactFeedback(style: FeedbackType) {
        if #available(iOS 10.0, *) {
            switch style {
            case .light:
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            case .medium:
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            case .heavy:
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            case .success:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            case .warning:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            case .error:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            case .change:
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            }
        }
    }
}
