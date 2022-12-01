//
//  AppDelegate.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2021/8/9.
//

@_exported import LTXiOSUtils
import UIKit

@UIApplicationMain
class AppDelegate: ModuleAppDelegate {
    override var services: [ModuleService] {
        let filterClasses: [AnyClass] = [
            AppDelegate.self,
            ModuleAppDelegate.self,
        ]

        let allClasses = RuntimeUtils.allClasses

        let resultClasses: [ModuleService] = allClasses.compactMap { item in
            if !filterClasses.compactMap({ "\($0)" }).contains("\(item)"),
               let clazz = item as? ModuleService.Type {
                return clazz.init()
            } else {
                return nil
            }
        }
        return resultClasses
    }

    required init() {
        super.init()
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
    }
}
