//
//  AppDelegate.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2021/8/9.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let rootViewController = ViewController()
        window?.rootViewController = rootViewController

        window?.makeKeyAndVisible()

        return true
    }
}