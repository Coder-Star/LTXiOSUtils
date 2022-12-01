//
//  ModuleServiceManager.swift
//  LTXiOSUtils
//  AppDelegate解耦
//  Created by CoderStar on 2020/4/24.
//

import CloudKit
import Foundation
import Intents
import UIKit
import UserNotifications

/*
 示例AppDelegate
 @UIApplicationMain
 class AppDelegate: ModuleAppDelegate {

     override var services: [ModuleService] {
         return [AppConfigModuleService(),
                 AppThemeModuleService(),
         ]
     }

     override init() {
         super.init()
         if window == nil {
             window = UIWindow()
         }
     }
 }
 */

/// 空协议，各组件模块去实现该协议

public protocol ModuleService: UIApplicationDelegate, UNUserNotificationCenterDelegate {
    /// 初始化方法，保证初始化
    init()

    /// 自定义事件
    func application(_ application: UIApplication, customEvent event: String, with param: [String: Any])
}

extension ModuleService {
    public func application(_ application: UIApplication, customEvent event: String, with param: [String: Any]) {}
}

extension ModuleService {
    /// window
    public var window: UIWindow? {
        // swiftlint:disable:next redundant_nil_coalescing
        return UIApplication.shared.delegate?.window ?? nil
    }
}

extension UIApplication {
    public var managerDelegate: ModuleAppDelegate? {
        return UIApplication.shared.delegate as? ModuleAppDelegate
    }
}

// MARK: - AppDelegate继承

open class ModuleAppDelegate: UIResponder, ModuleService {
    required public override init() {}

    /// 子类需要在构造函数中对其进行赋值
    public var window: UIWindow?

    /// 交由子类去重写，返回含有各模块实现ModuleService的类名称的plist文件地址
    /// plist文件需要是NSArray类型
    open var plistPath: String? { return nil }

    /// 交由子类去重写，返回各模块实现ModuleService的类
    open var services: [ModuleService] {
        guard let path = plistPath else {
            return []
        }
        guard let ModuleServiceNameArr = NSArray(contentsOfFile: path) else {
            return []
        }
        var ModuleServiceArr = [ModuleService]()
        for ModuleServiceName in ModuleServiceNameArr {
            if let ModuleServiceNameStr = ModuleServiceName as? String, let ModuleService = NSClassFromString(ModuleServiceNameStr), let module = ModuleService as? NSObject.Type {
                let service = module.init()
                if let result = service as? ModuleService {
                    ModuleServiceArr.append(result)
                }
            }
        }
        return ModuleServiceArr
    }

    /// 懒加载获取计算属性services，使其只计算一次
    private lazy var ModuleServices: [ModuleService] = {
        self.services
    }()

    @discardableResult
    private func apply<T, S>(_ work: (ModuleService, @escaping (T) -> Void) -> S?, completionHandler: @escaping ([T]) -> Void) -> [S] {
        let dispatchGroup = DispatchGroup()
        var results: [T] = []
        var returns: [S] = []

        for service in ModuleServices {
            dispatchGroup.enter()
            let returned = work(service) { result in
                results.append(result)
                dispatchGroup.leave()
            }
            if let returned = returned {
                returns.append(returned)
            } else {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completionHandler(results)
        }

        return returns
    }
}

extension ModuleAppDelegate {
    public func application(_ application: UIApplication, customEvent event: String, param: [String: Any]) {
        for service in ModuleServices {
            service.application(application, customEvent: event, with: param)
        }
    }
}

// swiftlint:disable missing_docs
// swiftlint:disable deployment_target
// swiftlint:disable reduce_boolean

// MARK: - AppInitializing APP启动时回调

extension ModuleAppDelegate {
    /// 进程启动还未进入状态保存
    @available(iOS 6.0, *)
    open func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        var result = false
        for service in ModuleServices {
            if service.application?(application, willFinishLaunchingWithOptions: launchOptions) ?? false {
                result = true
            }
        }
        return result
    }

    /// 启动基本完成，程序准备进行
    @available(iOS 3.0, *)
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        var result = false
        for service in ModuleServices {
            if service.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? false {
                result = true
            }
        }
        return result
    }

    /// 程序载入后执行
    @available(iOS 2.0, *)
    open func applicationDidFinishLaunching(_ application: UIApplication) {
        ModuleServices.forEach { $0.applicationDidFinishLaunching?(application) }
    }
}

// MARK: - AppStateAndSystemEvents，APP生命周期

extension ModuleAppDelegate {
    /// APP在前台
    @available(iOS 2.0, *)
    open func applicationDidBecomeActive(_ application: UIApplication) {
        for service in ModuleServices {
            service.applicationDidBecomeActive?(application)
        }
    }

    /// APP即将从前台切换到后台，在此期间，APP不接收消息及事件，比如来电话时
    @available(iOS 2.0, *)
    open func applicationWillResignActive(_ application: UIApplication) {
        for service in ModuleServices {
            service.applicationWillResignActive?(application)
        }
    }

    /// APP进入后台
    @available(iOS 4.0, *)
    open func applicationDidEnterBackground(_ application: UIApplication) {
        for service in ModuleServices {
            service.applicationDidEnterBackground?(application)
        }
    }

    /// APP即将从后台进入前台
    @available(iOS 4.0, *)
    open func applicationWillEnterForeground(_ application: UIApplication) {
        for service in ModuleServices {
            service.applicationWillEnterForeground?(application)
        }
    }

    /// APP即将退出，用于保存数据以及推出前的清理工作
    @available(iOS 2.0, *)
    open func applicationWillTerminate(_ application: UIApplication) {
        for service in ModuleServices {
            service.applicationWillTerminate?(application)
        }
    }

    /// APP即将锁屏
    @available(iOS 4.0, *)
    open func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        for service in ModuleServices {
            service.applicationProtectedDataWillBecomeUnavailable?(application)
        }
    }

    /// APP已经锁屏
    @available(iOS 4.0, *)
    open func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        for service in ModuleServices {
            service.applicationProtectedDataDidBecomeAvailable?(application)
        }
    }

    /// APP内存警告
    @available(iOS 2.0, *)
    open func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        for service in ModuleServices {
            service.applicationDidReceiveMemoryWarning?(application)
        }
    }

    /// 手动改变手机的系统日期与时间以及切换24小时、12小时制的时候也会触发该回调
    @available(iOS 2.0, *)
    open func applicationSignificantTimeChange(_ application: UIApplication) {
        for service in ModuleServices {
            service.applicationSignificantTimeChange?(application)
        }
    }
}

// MARK: - AppStateRestoration，APP数据状态保存

extension ModuleAppDelegate {
    @available(iOS 6.0, *)
    open func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        var result = false
        for service in ModuleServices {
            if service.application?(application, shouldSaveApplicationState: coder) ?? false {
                result = true
            }
        }
        return result
    }

    @available(iOS 6.0, *)
    open func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        var result = false
        for service in ModuleServices {
            if service.application?(application, shouldRestoreApplicationState: coder) ?? false {
                result = true
            }
        }
        return result
    }

    @available(iOS 6.0, *)
    open func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        for service in ModuleServices {
            if let viewController = service.application?(application, viewControllerWithRestorationIdentifierPath: identifierComponents, coder: coder) {
                return viewController
            }
        }

        return nil
    }

    @available(iOS 6.0, *)
    open func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
        for service in ModuleServices {
            service.application?(application, willEncodeRestorableStateWith: coder)
        }
    }

    @available(iOS 6.0, *)
    open func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
        for service in ModuleServices {
            service.application?(application, didDecodeRestorableStateWith: coder)
        }
    }
}

// MARK: - CloudKitHandling

extension ModuleAppDelegate {
    @available(iOS 10.0, *)
    open func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        for service in ModuleServices {
            service.application?(application, userDidAcceptCloudKitShareWith: cloudKitShareMetadata)
        }
    }
}

// MARK: - Continuing

extension ModuleAppDelegate {
    @available(iOS 8.0, *)
    open func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        var result = false
        for service in ModuleServices {
            if service.application?(application, willContinueUserActivityWithType: userActivityType) ?? false {
                result = true
            }
        }
        return result
    }

    /// 获取Universal link相关信息
    @available(iOS 8.0, *)
    open func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let returns = apply({ service, restorationHandler -> Bool? in
            service.application?(application, continue: userActivity, restorationHandler: restorationHandler)
        }, completionHandler: { results in
            let result = results.reduce([]) { $0 + ($1 ?? []) }
            restorationHandler(result)
        })

        return returns.reduce(false) { $0 || $1 }
    }

    @available(iOS 8.0, *)
    open func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        for service in ModuleServices {
            service.application?(application, didUpdate: userActivity)
        }
    }

    @available(iOS 8.0, *)
    open func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        for service in ModuleServices {
            service.application?(application, didFailToContinueUserActivityWithType: userActivityType, error: error)
        }
    }
}

// MARK: - DownloadingData

extension ModuleAppDelegate {
    // 开启Background Fetch后台模式后的回调
    // 如果实现了该方法，但没有开启Background Fetch后台模式则会出现警告信息
    @available(iOS 7.0, *)
    open func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        apply({ service, completionHandler -> Void? in
            service.application?(application, performFetchWithCompletionHandler: completionHandler)
        }, completionHandler: { results in
            let result = results.min { $0.rawValue < $1.rawValue } ?? .noData
            completionHandler(result)
        })
    }

    @available(iOS 7.0, *)
    open func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        apply({ service, completionHandler -> Void? in
            service.application?(
                application,
                handleEventsForBackgroundURLSession: identifier
            ) {
                completionHandler(())
            }
        }, completionHandler: { _ in
            completionHandler()
        })
    }
}

// MARK: - ExtensionTypes

extension ModuleAppDelegate {
    /// 是否允许第三方键盘
    @available(iOS 8.0, *)
    open func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        var result = false
        for service in ModuleServices {
            if service.application?(application, shouldAllowExtensionPointIdentifier: extensionPointIdentifier) ?? true {
                result = true
            }
        }
        return result
    }
}

// MARK: - HandlingActions

extension ModuleAppDelegate {
    /// 3D touch点击回调
    @available(iOS 9.0, *)
    open func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        apply({ service, completionHandler -> Void? in
            service.application?(application, performActionFor: shortcutItem, completionHandler: completionHandler)
        }, completionHandler: { results in
            // if any service handled the shortcut, return true
            let result = results.reduce(false) { $0 || $1 }
            completionHandler(result)
        })
    }
}

// MARK: - HealthKitInteracting

extension ModuleAppDelegate {
    @available(iOS 9.0, *)
    open func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        for service in ModuleServices {
            service.applicationShouldRequestHealthAuthorization?(application)
        }
    }
}

// MARK: - InterfaceGeometry，APP屏幕转换

extension ModuleAppDelegate {
    @available(iOS 2.0, *)
    open func application(_ application: UIApplication, willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        for service in ModuleServices {
            service.application?(application, willChangeStatusBarOrientation: newStatusBarOrientation, duration: duration)
        }
    }

    @available(iOS 2.0, *)
    open func application(_ application: UIApplication, didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation) {
        for service in ModuleServices {
            service.application?(application, didChangeStatusBarOrientation: oldStatusBarOrientation)
        }
    }

    @available(iOS 2.0, *)
    open func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
        for service in ModuleServices {
            service.application?(application, willChangeStatusBarFrame: newStatusBarFrame)
        }
    }

    @available(iOS 2.0, *)
    open func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect) {
        for service in ModuleServices {
            service.application?(application, didChangeStatusBarFrame: oldStatusBarFrame)
        }
    }
}

// MARK: - UNUserNotification，推送通知相关

extension ModuleAppDelegate: UNUserNotificationCenterDelegate {
    /// 后台发送通知时，APP处于前台时会回调该方法
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        for service in ModuleServices {
            service.userNotificationCenter?(center, willPresent: notification, withCompletionHandler: completionHandler)
        }
    }

    /// 点击推送横幅时，启动APP并回调该方法
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        for service in ModuleServices {
            service.userNotificationCenter?(center, didReceive: response, withCompletionHandler: completionHandler)
        }
    }

    @available(iOS 12.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        for service in ModuleServices {
            service.userNotificationCenter?(center, openSettingsFor: notification)
        }
    }
}

// MARK: - RemoteNotification

extension ModuleAppDelegate {
    /// APP获取token回调，返回数据为16进制的Data
    @available(iOS 3.0, *)
    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        for service in ModuleServices {
            service.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }

    /// APP获取token失败回调
    @available(iOS 3.0, *)
    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        for service in ModuleServices {
            service.application?(application, didFailToRegisterForRemoteNotificationsWithError: error)
        }
    }

    /// 后台发送静默推送时，回调该方法，APP收到后大约可以执行30秒，APP处于前台及后台时都可以收到，APP被杀死收不到
    @available(iOS 7.0, *)
    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        apply({ service, completionHandler -> Void? in
            service.application?(
                application,
                didReceiveRemoteNotification: userInfo,
                fetchCompletionHandler: completionHandler
            )
        }, completionHandler: { results in
            let result = results.min { $0.rawValue < $1.rawValue } ?? .noData
            completionHandler(result)
        })
    }
}

// MARK: - SiriKitHandling

extension ModuleAppDelegate {
    @available(iOS 11.0, *)
    open func application(_ application: UIApplication, handle intent: INIntent, completionHandler: @escaping (INIntentResponse) -> Void) {
        apply({ service, completionHandler -> Void? in
            service.application?(application, handle: intent, completionHandler: completionHandler)
        }, completionHandler: { results in
            let result = results.min { $0.hashValue < $1.hashValue } ?? INIntentResponse()
            completionHandler(result)
        })
    }
}

// MARK: - URLOpening，外部调用URL打开此应用

extension ModuleAppDelegate {
    @available(iOS 9.0, *)
    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        var result = false
        for service in ModuleServices {
            if service.application?(app, open: url, options: options) ?? false {
                result = true
            }
        }
        return result
    }
}

// MARK: - WatchKitInteracting

extension ModuleAppDelegate {
    @available(iOS 8.2, *)
    open func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable: Any]?, reply: @escaping ([AnyHashable: Any]?) -> Void) {
        for service in ModuleServices {
            service.application?(application, handleWatchKitExtensionRequest: userInfo, reply: reply)
        }
        apply({ service, reply -> Void? in
            service.application?(application, handleWatchKitExtensionRequest: userInfo, reply: reply)
        }, completionHandler: { results in
            let result = results.reduce([:]) { initial, next in
                var initial = initial
                for (key, value) in next ?? [:] {
                    initial[key] = value
                }
                return initial
            }
            reply(result)
        })
    }
}
