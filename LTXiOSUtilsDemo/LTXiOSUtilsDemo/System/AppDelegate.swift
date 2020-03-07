//
//  AppDelegate.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2019/8/2.
//  Copyright © 2019年 李天星. All rights reserved.
//

/*
 说一下PluggableAppDelegate这个库的原理：组合模式
PluggableApplicationDelegate实现了UIApplicationDelegate协议，并在扩展中默认实现了所有方法，在生命周期的各个方法中调用了ApplicationService及其子类相对应生命周期的方法，从而实现解耦，其中ApplicationService也实现了UIApplicationDelegate协议。
 */

import UIKit
import PluggableAppDelegate

@UIApplicationMain
class AppDelegate: PluggableApplicationDelegate {

    override var services: [ApplicationService] {
        return [ThirdLibApplicationService(),
                RootVCApplicationService(),
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
