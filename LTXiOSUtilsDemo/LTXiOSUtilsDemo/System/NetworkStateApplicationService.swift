//
//  NetworkStateApplicationService.swift
//  LTXiOSUtilsDemo
//  网络状态监听
//  Created by 李天星 on 2020/1/11.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import PluggableAppDelegate
import Reachability

final class NetworkStateApplicationService: NSObject,ApplicationService {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        guard let reachability = try? Reachability() else {
            return true
        }

        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                QL1("WiFi数据")
            } else {
                QL1("蜂窝网络")
            }
        }

        reachability.whenUnreachable = { _ in
            QL1("没有网络")
        }
        do {
            try reachability.startNotifier()
        } catch {
            QL1("无法启动网络监听")
        }

        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            QL1("could not start reachability notifier")
        }
        return true
    }

    @objc func reachabilityChanged(note: Notification) {
        guard let reachability = try? Reachability() else {
            return
        }
        QL1(reachability.connection.description)
    }
}
