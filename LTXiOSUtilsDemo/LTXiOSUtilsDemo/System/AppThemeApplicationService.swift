//
//  AppThemeApplicationService.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/2/15.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import PluggableAppDelegate

final class AppThemeApplicationService: NSObject,ApplicationService {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        initTheme()
        return true
    }
}

extension AppThemeApplicationService {
    private func initTheme() {
        // 设置导航栏默认的背景颜色
        WRNavigationBar.defaultNavBarBarTintColor = AppTheme.mainColor
        // 设置导航栏所有按钮的默认颜色
        WRNavigationBar.defaultNavBarTintColor = .white
        // 设置导航栏标题默认颜色
        WRNavigationBar.defaultNavBarTitleColor = .white
        // 统一设置状态栏样式
        WRNavigationBar.defaultStatusBarStyle = .lightContent

        ToolBarView.clearButtonColor = AppTheme.mainColor
        ToolBarView.doneButtonColor = AppTheme.mainColor
    }
}
