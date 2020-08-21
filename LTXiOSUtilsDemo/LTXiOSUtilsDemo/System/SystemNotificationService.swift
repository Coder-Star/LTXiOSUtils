//
//  SystemNotificationService.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/8/20.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import AVFoundation

final class SystemNotificationService: NSObject, ApplicationService {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        initNotification()
        return true
    }

    private func initNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: AVAudioSession.interruptionNotification, object: nil)
    }

    @objc
    func handleNotification(_ notification: Notification) {
        Log.d(notification)
        Log.d("录音打断")
        guard let allKeys = notification.userInfo?.keys else {
            return
        }
        // 中断事件类型
        if allKeys.contains(AVAudioSessionInterruptionTypeKey) {
            let audioInterruptionType = notification.userInfo![AVAudioSessionInterruptionTypeKey]
            Log.d(audioInterruptionType)
        }

        // 中断的音频录制是否可以恢复录制
        if allKeys.contains(AVAudioSessionInterruptionOptionKey) {
            Log.d(notification.userInfo![AVAudioSessionInterruptionOptionKey])
        }
    }
}
