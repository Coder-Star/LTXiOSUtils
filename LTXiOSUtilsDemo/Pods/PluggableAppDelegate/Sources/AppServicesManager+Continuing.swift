//
//  AppServicesManager+Continuing.swift
//  PluggableAppDelegate
//
//  Created by Mikhail Pchelnikov on 31/07/2018.
//  Copyright © 2018 Michael Pchelnikov. All rights reserved.
//

import UIKit

extension PluggableApplicationDelegate {

    // Called on the main thread as soon as the user indicates they want to continue an activity in your application. The NSUserActivity object may not be available instantly,
    // so use this as an opportunity to show the user that an activity will be continued shortly.
    // For each application:willContinueUserActivityWithType: invocation, you are guaranteed to get exactly one invocation of application:continueUserActivity: on success,
    // or application:didFailToContinueUserActivityWithType:error: if an error was encountered.
    @available(iOS 8.0, *)
    open func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        var result = false
        for service in _services {
            if service.application?(application, willContinueUserActivityWithType: userActivityType) ?? false {
                result = true
            }
        }
        return result
    }

    // Called on the main thread after the NSUserActivity object is available. Use the data you stored in the NSUserActivity object to re-create what the user was doing.
    // You can create/fetch any restorable objects associated with the user activity, and pass them to the restorationHandler. They will then have the UIResponder restoreUserActivityState: method
    // invoked with the user activity. Invoking the restorationHandler is optional. It may be copied and invoked later, and it will bounce to the main thread to complete its work and call
    // restoreUserActivityState on all objects.
    @available(iOS 8.0, *)
    open func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let returns = apply({ (service, restorationHandler) -> Bool? in
            service.application?(application, continue: userActivity, restorationHandler: restorationHandler)
        }, completionHandler: { results in
            let result = results.reduce([], { $0 + ($1 ?? []) }) 
            restorationHandler(result)
        })

        return returns.reduce(false, { $0 || $1 })
    }

    // This is called on the main thread when a user activity managed by UIKit has been updated. You can use this as a last chance to add additional data to the userActivity.
    @available(iOS 8.0, *)
    open func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        for service in _services {
            service.application?(application, didUpdate: userActivity)
        }
    }

    // If the user activity cannot be fetched after willContinueUserActivityWithType is called, this will be called on the main thread when implemented.
    @available(iOS 8.0, *)
    open func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        for service in _services {
            service.application?(application, didFailToContinueUserActivityWithType: userActivityType, error: error)
        }
    }
}
