//
//  AppConfigApplicationService.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2022/10/17.
//

import Foundation

class AppConfigApplicationService: NSObject, ApplicationService {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initConfig()

        let rootViewController = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = rootViewController

        window?.makeKeyAndVisible()

        if let delegate = UIApplication.shared.managerDelegate {
            Log.d(delegate)
        }

        return true
    }

    private func initConfig() {
        Log.enabled = true
    }
}
