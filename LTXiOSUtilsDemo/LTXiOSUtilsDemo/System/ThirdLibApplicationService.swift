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
        // 自定义渠道
        buglyConfig.channel = "APP"
        buglyConfig.delegate = self

        // 设置用户ID
        Bugly.setUserIdentifier("CoderStar")
        Bugly.start(withAppId: "68933b555c", config: buglyConfig)
        /*
        let exception = NSException(name: NSExceptionName(rawValue: "错误名称"), reason: "错误原因", userInfo: ["key":"value"])
        Bugly.report(exception)

        let error = NSError(domain: "com.coderstar", code: 1, userInfo: ["key":"value"])
        Bugly.reportError(error)

        Bugly.reportException(withCategory: 1, name: "错误名称", reason: "原因", callStack: [], extraInfo: ["key":"value"], terminateApp: false)

         上面为自定义异常部分，在后台 错误分析 模块中
        */
    }

    func attachment(for exception: NSException?) -> String? {
        // 在附件crash_attach.log中看
        // 如果返回信息为nil，则不会生成crash_attach.log文件
        return nil
    }
}
