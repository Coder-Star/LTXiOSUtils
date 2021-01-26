//
//  DeviceInfo.swift
//  LTXiOSUtilsDemo
//  设备相关信息
//  Created by 李天星 on 2021/1/26.
//  Copyright © 2021 李天星. All rights reserved.
//

import Foundation
import UIKit

struct DeviceInfo {

    static func printDeviceInfo(window: UIWindow?, viewController: UIViewController) {
        // safeAreaInsets top为状态栏高度，通过判断bottom是否大于0判断设备是否为刘海屏
        Log.d("safeAreaInsets: \(window?.safeAreaInsets)")
    }
}
