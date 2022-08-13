//
//  AppDelegate.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2021/8/9.
//

@_exported import LTXiOSUtils
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initConfig()

        window = UIWindow(frame: UIScreen.main.bounds)

        let rootViewController = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = rootViewController

        window?.makeKeyAndVisible()

        return true
    }

    private func initConfig() {
        Log.enabled = true
    }
}
