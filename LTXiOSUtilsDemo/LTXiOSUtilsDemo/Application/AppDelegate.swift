//
//  AppDelegate.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2021/8/9.
//

@_exported import LTXiOSUtils
import UIKit

@UIApplicationMain
class AppDelegate: ApplicationServiceManagerDelegate {
    override var services: [ApplicationService] {
        return [
            AppConfigApplicationService(),
        ]
    }

    override init() {
        super.init()
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
    }
}
