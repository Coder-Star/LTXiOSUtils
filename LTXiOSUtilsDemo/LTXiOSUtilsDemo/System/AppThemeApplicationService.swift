//
//  AppThemeApplicationService.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/2/15.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

final class AppThemeApplicationService: NSObject, ApplicationService {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        initTheme()
        return true
    }
}

extension AppThemeApplicationService {
    private func initTheme() {
        ToolBarView.clearButtonColor = AppTheme.mainColor
        ToolBarView.doneButtonColor = AppTheme.mainColor
    }
}
