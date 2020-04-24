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

@UIApplicationMain
class AppDelegate: ApplicationServiceManagerDelegate {

    /*
     可以将moduleList的获取方式改为从plist文件中进行获取，配置内容为各组件实现ApplicationService的类
     格式为 组件名.类名
     这样就可以达到各组件能够接收到AppDelegate中的系统事件
     如果使用类似MGJRouter的组件通信工具，就可以在各组件的 didFinishLaunchingWithOptions方法中注册url
     */
    let moduleList: [AnyClass?] = ["AppConfigApplicationService".class,
                      "AppThemeApplicationService".class,
                      "ThirdLibApplicationService".class,
                      "NetworkStateApplicationService".class,
                      "RootVCApplicationService".class]

    override var services: [ApplicationService] {
        var applicationServiceList = [ApplicationService]()
        for item in moduleList {
            if let module = item as? NSObject.Type {
                let service = module.init()
                if let result = service as? ApplicationService {
                    applicationServiceList.append(result)
                }
            }
        }

        return applicationServiceList
//        return [AppConfigApplicationService(),
//                AppThemeApplicationService(),
//                ThirdLibApplicationService(),
//                NetworkStateApplicationService(),
//                RootVCApplicationService()
//        ]
    }

    override init() {
        super.init()
        if window == nil {
            window = UIWindow()
        }
    }
}
