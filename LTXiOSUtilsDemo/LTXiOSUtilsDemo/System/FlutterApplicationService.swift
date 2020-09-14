//
//  FlutterApplicationService.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/14.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import Flutter
import FlutterPluginRegistrant

final class FlutterApplicationService: FlutterAppDelegate, ApplicationService {

    lazy var flutterEngine = FlutterEngine(name: "my flutter engine", project: nil)

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        runFlutter()

        return true
    }

    func runFlutter() {
        // withEntrypoint表示flutter端入口函数，如果传入nil，则使用默认主函数，main()
        flutterEngine?.run(withEntrypoint: nil)
        GeneratedPluginRegistrant.register(with: self.flutterEngine)
    }

}
