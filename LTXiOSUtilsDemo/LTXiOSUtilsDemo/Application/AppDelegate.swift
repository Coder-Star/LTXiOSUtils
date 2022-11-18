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
        let filterClasses: [AnyClass] = [
            AppDelegate.self,
            ApplicationServiceManagerDelegate.self,
        ]

        let resultClasses: [ApplicationService] = RuntimeUtils.getAllClasses { item in
            if !filterClasses.compactMap({ "\($0)" }).contains("\(item)"),
               let clazz = item as? ApplicationService.Type {
                return clazz.init()
            } else {
                return nil
            }
        }
        print(resultClasses.count)
        return resultClasses
    }

    required init() {
        super.init()
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
    }
}
