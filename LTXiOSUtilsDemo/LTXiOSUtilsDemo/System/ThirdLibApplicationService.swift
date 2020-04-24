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
    }
}
