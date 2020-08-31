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
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let audioInterruptionType = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else {
            return
        }

        if audioInterruptionType == AVAudioSession.InterruptionType.began.rawValue {
            //中断开始

        } else if audioInterruptionType == AVAudioSession.InterruptionType.ended.rawValue {
            // 中断结束
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {
                return
            }
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                // 可以继续处理
                SoundRecorder.shared.pause()
            }
        }
    }
}
