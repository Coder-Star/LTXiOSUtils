//
//  NotificationApplicationService.swift
//  LTXiOSUtilsDemo
//  本地、远程通知相关
//  Created by 李天星 on 2020/9/30.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

final class NotificationApplicationService: NSObject, ApplicationService {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        /// 当APP处于死亡状态，收到推送，点击推送消息启动APP，可以通过下面的方式获取到推送消息，
        /// 直接点击图标启动APP参数为空
        if let pushInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] {
            HUD.showText("\(pushInfo)", delayTime: 5)
        }

        requestAuthorization()

        // 向APNs请求token
        UIApplication.shared.registerForRemoteNotifications()

        initXGPush(launchOptions: launchOptions)

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Log.d("推送deviceToken：\(deviceToken.hexString)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.d("推送注册失败，失败信息为：\(error)")
    }

    /// 静默推送时回调此方法，大概可以执行30s，APP处于前台、后台时都可回调此方法
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Log.d(userInfo)
        // 此闭包告诉系统是否执行完毕
        completionHandler(.noData)
    }

    /// APP处于前台时才会回调该方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        Log.d("原生收到推送")
        Log.d(notification.request.trigger)

        guard let trigger = notification.request.trigger else {
            completionHandler([.alert, .sound, .badge])
            return
        }

        if trigger.isKind(of: UNPushNotificationTrigger.self) {
            /// 远程推送
        } else if trigger.isKind(of: UNLocationNotificationTrigger.self) {
            /// 本地推送
        }
        /// 回调的设置决定前台时推送来时的效果
        completionHandler([.alert, .sound, .badge])
    }

    /// 原生点击推送
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        Log.d("原生点击推送")
        Log.d(response)

        guard let trigger = response.notification.request.trigger else {
            completionHandler()
            return
        }
        if trigger.isKind(of: UNPushNotificationTrigger.self) {
            /// 远程推送
            let userInfo = response.notification.request.content.userInfo
            Log.d(userInfo)

            if let textInputNotificationResponse = response as? UNTextInputNotificationResponse {
                let userText = textInputNotificationResponse.userText
                Log.d(userText)
            }

            let actionIdentifier = response.actionIdentifier
            Log.d(actionIdentifier)
            if actionIdentifier == "action.look" {}

        } else if trigger.isKind(of: UNLocationNotificationTrigger.self) {
            /// 本地推送
        }
        completionHandler()
    }
}

extension NotificationApplicationService {
    /// 获取权限
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        // 必须设置
        center.delegate = self
        center.getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .authorized:
                // 权限通过
                self?.setNotificationCategories()
                return
            case .notDetermined:
                // 没有请求授权过，请求权限
                center.requestAuthorization(options: [.alert, .sound, .badge]) { accepted, error in
                    if !accepted {
                        Log.d("用户不允许推送\(String(describing: error))")
                    } else {
                        self?.setNotificationCategories()
                    }
                }
                // 权限关闭
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
                // 临时权限
            case .provisional:
                break
            case .ephemeral:
                break
            }
        }
    }

    func setNotificationCategories() {
        let center = UNUserNotificationCenter.current()
        /**
         options是一个枚举，包括authenticationRequired、foreground、destructive
         authenticationRequired：需要解锁显示，点击不会进去APP
         foreground：黑色文字，点击不会进app
         destructive：红色文字，点击不会进app
         */
        let lookAction = UNNotificationAction(identifier: "action.look", title: "查看邀请", options: .authenticationRequired)
        let joinAction = UNNotificationAction(identifier: "action.join", title: "接受邀请", options: .foreground)
        let cancelAction = UNNotificationAction(identifier: "action.cancel", title: "取消邀请", options: .destructive)

        let inputAction = UNTextInputNotificationAction(identifier: "action.input", title: "输入", options: .foreground, textInputButtonTitle: "确定", textInputPlaceholder: "请输入接受邀请备注")

        // 锁屏及在通知中心收到推送，侧滑，会展示 action
        let category = UNNotificationCategory(identifier: "join_category", actions: [lookAction, joinAction, inputAction, cancelAction], intentIdentifiers: [], options: .customDismissAction)
        center.setNotificationCategories([category])
    }
}

// MARK: - TAPNs相关

extension NotificationApplicationService {
    func initXGPush(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {

        if let launchOptions = launchOptions as? NSMutableDictionary {
            XGPush.defaultManager().launchOptions = launchOptions
        }
        XGPush.defaultManager().isEnableDebug = true // 启用debug模式

        XGPush.defaultManager().deviceNotificationIsAllowed { _ in
        }

        // 设置成上海集群
        XGPush.defaultManager().configureClusterDomainName("tpns.sh.tencent.com")

        // swiftlint:disable number_separator
        /// 内部流程已经申请权限以及获取token了，启动后，不再走原生的代理，通过原生设置的action也没有效果
//        XGPush.defaultManager().startXG(withAccessID: 1680001375, accessKey: "IYBJPGFD2RRO", delegate: self)
    }

    func XGAPI() {
        _ = XGPushTokenManager.default().deviceTokenString
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

    /// 统一接收消息的回调
    /// @param notification 消息对象(有2种类型NSDictionary和UNNotification具体解析参考示例代码)
    /// @note 此回调为前台收到通知消息及所有状态下收到静默消息的回调（消息点击需使用统一点击回调）
    /// 区分消息类型说明：xg字段里的msgtype为1则代表通知消息msgtype为2则代表静默消息
    /// 如果是静默通知，在后台接收到时，会触发该回调，也会触发原生的静默通知回调，此时要注意不要多次completionHandler，否则会引发Crash，可以通过消息字典里面是否有xg字段判断是否是TPNS平台的消息
    func xgPushDidReceiveRemoteNotification(_ notification: Any, withCompletionHandler completionHandler: ((UInt) -> Void)? = nil) {
        Log.d("收到通知")
        if let notification = notification as? UNNotification {
            Log.d("时间 \(notification.date)")
            Log.d("全部内容 \(notification.request.content.tx.getAllPropertysAndValue())")
        } else if let notification = notification as? NSDictionary {
            Log.d("全部内容 \(notification)")
        }
        if let completion = completionHandler {
            completion(UNNotificationPresentationOptions.alert.rawValue | UNNotificationPresentationOptions.badge.rawValue | UNNotificationPresentationOptions.sound.rawValue)
        }
    }

    /// 统一点击回调
    /// @param response 如果iOS 10+/macOS 10.14+则为UNNotificationResponse，低于目标版本则为NSDictionary
    func xgPushDidReceiveNotificationResponse(_ response: Any, withCompletionHandler completionHandler: @escaping () -> Void) {
        Log.d("统一点击回调 \(response)")
    }

    /**
     下面两个代理，如果上述两个统一入口方法没有被实现，就会走下面两个入口
     */

    func xgPush(_ center: UNUserNotificationCenter, willPresent notification: UNNotification?, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        Log.d(notification)
        completionHandler([.alert, .sound, .badge])
    }

    func xgPush(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse?, withCompletionHandler completionHandler: @escaping () -> Void) {
        Log.d("点击")
    }
}

extension NotificationApplicationService: XGPushTokenManagerDelegate {}
