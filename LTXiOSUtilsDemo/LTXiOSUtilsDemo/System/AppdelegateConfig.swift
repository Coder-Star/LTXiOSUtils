//
//  AppdelegateConfig.swift
//  LTXiOSUtilsDemo
//  APP配置
//  Created by 李天星 on 2019/11/20.
//  Copyright © 2019 李天星. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

class AppdelegateConfig {

    private init() {

    }

    /// 基础配置
    static func initConfig() {
        initLog()
        IQKeyboardManager.shared.enable = true
    }

    /// 日志设置
    static func initLog() {

    }
}
