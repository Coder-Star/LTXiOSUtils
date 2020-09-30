//
//  NotificationApplicationService.swift
//  LTXiOSUtilsDemo
//  本地、远程通知相关
//  Created by 李天星 on 2020/9/30.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import UIKit

final class NotificationApplicationService: NSObject, ApplicationService {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        /// 当APP处于死亡状态，收到推送、点击推送消息启动APP，可以通过下面的方式获取到推送消息
        //        let pushInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]
        //        Log.d(pushInfo)

        requestAuthorization()

        // 向APNs请求token
        //        UIApplication.shared.registerForRemoteNotifications()

        initXGPush()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Log.d("推送deviceToken：\(deviceToken.hexString)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.d("推送注册失败，失败信息为：\(error)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        Log.d("原生推送回调收到推送消息")
    }

}

extension NotificationApplicationService {

    func initXGPush() {
        XGPush.defaultManager().isEnableDebug = true // 启用debug模式

        XGPush.defaultManager().deviceNotificationIsAllowed { _ in

        }

        // 设置成上海集群
        XGPush.defaultManager().configureClusterDomainName("tpns.sh.tencent.com")

        XGPush.defaultManager().startXG(withAccessID: 1680001375, accessKey: "IYBJPGFD2RRO", delegate: self)
    }

    func XGAPI() {
        XGForFreeVersion.default()?.freeAccessId = 0 // 免费信鸽应用id，在启动之前调用
    }

}

extension NotificationApplicationService: XGPushDelegate {

    func xgPushDidRegisteredDeviceToken(_ deviceToken: String?, error: Error?) {
        Log.d("deviceToken\(String(describing: deviceToken))")
    }

    func xgPushDidRegisteredDeviceToken(_ deviceToken: String?, xgToken: String?, error: Error?) {
        Log.d("deviceToken\(String(describing: deviceToken))")
        Log.d("xgToken\(String(describing: xgToken))")
    }

    /// 收到消息
    func xgPushDidReceiveRemoteNotification(_ notification: Any, withCompletionHandler completionHandler: ((UInt) -> Void)? = nil) {
        Log.d("收到通知 \(notification)")

        if let completion = completionHandler {
            completion(UNNotificationPresentationOptions.alert.rawValue | UNNotificationPresentationOptions.badge.rawValue | UNNotificationPresentationOptions.sound.rawValue)
        }
    }

    // 统一点击回调
    func xgPushDidReceiveNotificationResponse(_ response: Any, withCompletionHandler completionHandler: @escaping () -> Void) {
        Log.d("统一点击回调 \(response)")
    }
}

extension NotificationApplicationService: XGPushTokenManagerDelegate {

}

extension NotificationApplicationService {
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                // 权限通过
                return
            case .notDetermined:
                // 没有请求授权过
                center.requestAuthorization(options: [.alert, .sound, .badge]) { accepted, error in
                    if !accepted {
                        Log.d("用户不允许推送\(String(describing: error))")
                    }
                }
            case .denied:
                DispatchQueue.main.async {
                    let alertController = UIAlertController.getAlert(style: .alert, title: "消息推送已关闭", message: "想要及时获取消息。点击“设置”，开启通知。", sureTitle: "设置", cancelTitle: "取消", cancelBlock: nil) {
                        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    if alertController != nil {
                        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController?.present(alertController!, animated: true, completion: nil)
                    }
                }
            case .provisional:
                break
            case .ephemeral:
                break
            @unknown default:
                break
            }
        }
    }
}
