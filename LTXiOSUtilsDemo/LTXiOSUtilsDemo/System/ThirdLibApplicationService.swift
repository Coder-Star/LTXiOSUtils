//
//  ThirdLibApplicationService.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/1/9.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
import GDPerformanceView_Swift

final class ThirdLibApplicationService: NSObject, ApplicationService {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        initThirdLib()
        return true
    }

    func initThirdLib() {

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        PerformanceMonitor.shared().start()

        // 防重复点击
        UIButton.RepeatClickDefaultDuration = 0.55
        UIButton.initRepeatClickMethod()

        initBugly()
    }
}

extension ThirdLibApplicationService: BuglyDelegate {

    func initBugly() {
        let buglyConfig = BuglyConfig()
        // 卡顿监控开关
        buglyConfig.blockMonitorEnable = true
        // 卡顿监控间隔
        buglyConfig.blockMonitorTimeout = 3
        buglyConfig.reportLogLevel = .verbose
        // 自定义渠道 设置关键数据，在跟踪数据-自定义数据中展示
        buglyConfig.channel = "APP"

        buglyConfig.delegate = self

        // 设置用户ID
        Bugly.setUserIdentifier("CoderStar")
        // 设置关键数据，在跟踪数据-自定义数据中展示
        Bugly.setUserValue("17812345678", forKey: "phone")

        // 跟踪数据-自定义数据 在附件信息valueMapOthers.txt中也有体现

        Bugly.start(withAppId: "68933b555c", config: buglyConfig)
        Bugly.setTag(160761)
        let exception = NSException(name: NSExceptionName(rawValue: "不带分类异常名称"), reason: "", userInfo: ["NSException": "info"])
        Bugly.report(exception)

        let error = NSError(domain: "com.coderstar", code: 1, userInfo: ["key": "value"])
        Bugly.reportError(error)
        Bugly.setTag(160764)
        // category必须是 类型(Cocoa=3,CSharp=4,JS=5,Lua=6) 如果不是这几种之内 则不会上传
        Bugly.reportException(withCategory: 3, name: "带有分类异常名称", reason: "", callStack: [], extraInfo: ["reportException": "info"], terminateApp: false)

        // 上面为自定义异常部分，在后台 错误分析 模块中
    }

    func attachment(for exception: NSException?) -> String? {
        // 在附件crash_attach.log中看
        return nil
    }
}
