//
//  AppConfigApplicationService.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/3/25.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import SwiftyJSON

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
extension AppConfigApplicationService: CrashHandlerDelegate {
    private func catchCrash() {
        // 注册全局捕获
        CrashHandler.enabled = true
        CrashHandler.delegate = self
    }

    func didCatchCarsh(carshInfo: CrashInfoModel) {
        Log.d(carshInfo.name)
        Log.d(carshInfo.callStack)
    }
}
