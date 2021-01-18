//
//  main.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/12/25.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

let kAppStartLaunchTimeInterval = Date().timeIntervalSince1970

class MyApplication: UIApplication {
    // 可以监听所有的事件
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
    }
}

private let kPointer = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(
    to: UnsafeMutablePointer<Int8>?.self,
    capacity: Int(CommandLine.argc)
)

UIApplicationMain(
    CommandLine.argc,
    kPointer,
    NSStringFromClass(MyApplication.self),
    NSStringFromClass(AppDelegate.self)
)
