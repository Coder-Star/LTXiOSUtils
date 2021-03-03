//
//  FlutterApplicationService.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/14.
//  Copyright © 2020 李天星. All rights reserved.
//

/**
 在iOS真机上以调试方式跑Flutter程序时，第二次进入就会闪退，如果签名发布就没问题
 */

import Foundation

final class FlutterApplicationService: FlutterAppDelegate, ApplicationService {

    // FlutterEngine 的寿命可能与 FlutterViewController 相同，也可能超过 FlutterViewController
    // 在展示UI前，你的应用和 plugins 可以与 Flutter 和 Dart 逻辑交互
    // 当展示 FlutterViewController 时，第一帧画面将会更快展现
    lazy var flutterEngine = FlutterEngine(name: "my flutter engine", project: nil)

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        runFlutter()

        return true
    }

    func runFlutter() {
        // withEntrypoint表示flutter端入口函数，如果传入nil，则使用默认主函数，main()
        // initialRoute表示默认路由地址，即进入Flutter环境的第一个页面，如 "/component_list"
        /// 启动Flutter引擎
        flutterEngine.run(withEntrypoint: nil, initialRoute: nil)
        // 这样会启动会用lib/main1.dart 文件的 main1() 函数取代 lib/main.dart 的 main() 函数
//        flutterEngine.run(withEntrypoint: "main1", libraryURI: "main1.dart")

        // 注册插件，使准备好的插件被加载
        // 其中就是调用一次各个插件的registerWithRegistrar方法
        GeneratedPluginRegistrant.register(with: flutterEngine)

    }

}
