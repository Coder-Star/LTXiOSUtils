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

    var reachability: Reachability? //需要定义成全局属性，因为这个属性需要在应用周期内存活

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        do {
            reachability = try? Reachability()
        }

        // MARK: - 1、闭包监听
//        reachability?.whenReachable = { reachability in
//            if reachability.connection == .wifi {
//                Log.d("WiFi数据")
//            } else {
//                Log.d("蜂窝网络")
//            }
//        }
//
//        reachability?.whenUnreachable = { _ in
//            Log.d("没有网络")
//        }

        // MARK: - 2、通知监听
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)

        do {
            try reachability?.startNotifier()
        } catch {
            Log.d("无法启动网络监听")
        }

        return true
    }

    @objc func reachabilityChanged(note: Notification) {
        if let reachability = note.object as? Reachability {
            Log.d(reachability.connection.description)
            DispatchQueue.main.delay(3) {
                switch reachability.connection {
                case .none:
                    HUD.showText("无网络")
                case .unavailable:
                    HUD.showText("网络无法连接")
                case .wifi:
                    HUD.showText("您当前处于WiFi网络，请放心使用")
                case .cellular:
                    HUD.showText("您当前处于蜂窝网络，请注意使用")
                }
            }
        }
    }

    deinit {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
}
