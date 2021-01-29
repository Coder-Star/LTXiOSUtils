//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by 李天星 on 2020/10/9.
//  Copyright © 2020 李天星. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

// 自定义推送查看详情时展示的内容，会覆盖默认的展示内容，包括附件

/**
 UNNotificationExtensionCategory，定义在info.plist文件中 可以是一个数组，也可以是个字符串，定义成数组的时候就可以实现多个Category公用一个页面

 如果不想使用storyboard，也可以使用NSExtensionPrincipalClass（填对应ViewController的名称）代替 NSExtensionMainStoryboard 
 */

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didReceive(_ notification: UNNotification) {
        print(notification)
        self.label?.text = notification.request.content.body
    }

    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
    }

}
