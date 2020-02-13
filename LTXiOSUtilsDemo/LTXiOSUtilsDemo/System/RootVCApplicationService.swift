//
//  RootVCApplicationService.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/1/9.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import PluggableAppDelegate
import XHLaunchAd
import LTXiOSUtils

final class RootVCApplicationService: NSObject,ApplicationService {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let rootViewController = HomeTabBarController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
//        setLaunchAd()
        initTheme()
        return true
    }
}

extension RootVCApplicationService: XHLaunchAdDelegate {
    /// 设置开屏广告
    private func setLaunchAd() {
        XHLaunchAd.setLaunch(.launchScreen)
        XHLaunchAd.setWaitDataDuration(1)
        let requestParam = RequestParam(baseUrl: NetworkConstant.appUrl, path: NetworkConstant.launchAdData)
        requestParam.method = .get
        NetworkManager.sendRequest(requestParam: requestParam, success: { data in
            QL1(data)
            if let adModel = AdModel(JSONString: data.description) {
                let config = XHLaunchImageAdConfiguration()
                config.duration = adModel.duration!
                config.skipButtonType = adModel.skipBtnType!
                config.imageNameOrURLString = adModel.imgUrl!
                config.imageOption = .cacheInBackground
                config.showFinishAnimate = adModel.animationType!
                config.openModel = adModel.actionUrl!
                XHLaunchAd.imageAd(with: config, delegate: self)
            }
        }, failure: { _ in
            QL1(XHLaunchAd.cacheImageURLString())
            let url = XHLaunchAd.cacheImageURLString()
            if url.isNotEmpty {
                let config = XHLaunchImageAdConfiguration()
                config.duration = 5
                config.skipButtonType = .timeText
                config.imageNameOrURLString = url
                config.imageOption = .cacheInBackground
                config.showFinishAnimate = .fadein
                XHLaunchAd.imageAd(with: config)
            }
        })
    }

    func xhLaunchAd(_ launchAd: XHLaunchAd, clickAtOpenModel openModel: Any, click clickPoint: CGPoint) -> Bool {
        QL1(openModel)
        return true
    }
}

extension RootVCApplicationService {
    private func initTheme() {
        // 设置导航栏默认的背景颜色
        WRNavigationBar.defaultNavBarBarTintColor = AppTheme.mainColor
        // 设置导航栏所有按钮的默认颜色
        WRNavigationBar.defaultNavBarTintColor = .white
        // 设置导航栏标题默认颜色
        WRNavigationBar.defaultNavBarTitleColor = .white
        // 统一设置状态栏样式
        WRNavigationBar.defaultStatusBarStyle = .lightContent
    }
}
