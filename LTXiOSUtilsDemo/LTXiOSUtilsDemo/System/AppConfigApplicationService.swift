//
//  AppConfigApplicationService.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/3/25.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

final class AppConfigApplicationService: NSObject, ApplicationService {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        initLogConfig()
        initUrlInfo()
        initRegisterUrl()
        catchCrash()
        return true
    }
}

// MARK: - 网络设置
extension AppConfigApplicationService {
    private func initUrlInfo() {
        NetworkConstant.initUrlInfo()
    }
}

// MARK: - 组件注册
extension AppConfigApplicationService {
    private func initRegisterUrl() {
        MGJRouterDemoViewController.registerRouter()
    }
}

// MARK: - 日志设置
extension AppConfigApplicationService {
    /// 日志设置
    private func initLogConfig() {
        Log.enabled = true
        #if DEBUG
        Log.minShowLogLevel = .debug
        #else
        Log.minShowLogLevel = .info
        #endif
    }
}

// MARK: - 全局捕获异常
extension AppConfigApplicationService {
    private func catchCrash() {
        // 注册全局捕获
        CrashManager.registerHandler()

        // 输出错误日志信息，耗时，可开线程读取
        Log.d(CrashManager.readAllCrashInfo())
    }
}
