//
//  AppDelegate.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2019/8/2.
//  Copyright © 2019年 李天星. All rights reserved.
//

import UIKit
import PluggableAppDelegate

@UIApplicationMain
class AppDelegate: PluggableApplicationDelegate {

    override var services: [ApplicationService] {
        return [RootVCApplicationService(),
                ThirdLibApplicationService(),
                NetworkStateApplicationService(),
                AppThemeApplicationService()
        ]
    }

    override init() {
        super.init()
        if window == nil {
            window = UIWindow()
        }
    }
}
