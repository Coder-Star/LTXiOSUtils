//
//  AppConfigApplicationService.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/3/25.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import PluggableAppDelegate

final class AppConfigApplicationService: NSObject, ApplicationService {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        initUrlInfo()
        return true
    }
}

extension AppConfigApplicationService {
    private func initUrlInfo() {
        NetworkConstant.initUrlInfo()
    }
}
